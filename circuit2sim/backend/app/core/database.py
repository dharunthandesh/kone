"""SQLite database management for Circuit2Sim.

Handles projects, asynchronous analysis jobs, circuit IR versions, and model generation history.
"""

import json
import sqlite3
import threading
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional
from circuit2sim.backend.app.core.config import settings


class Database:
    _lock = threading.Lock()

    def __init__(self, db_path: Path = settings.DATABASE_PATH):
        self.db_path = db_path
        self._init_db()

    def get_connection(self) -> sqlite3.Connection:
        conn = sqlite3.connect(str(self.db_path), check_same_thread=False)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA journal_mode = WAL")
        conn.execute("PRAGMA foreign_keys = ON")
        return conn

    def _init_db(self):
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()

            # Projects table
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS projects (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                description TEXT,
                status TEXT NOT NULL DEFAULT 'created',
                schematic_filename TEXT,
                schematic_path TEXT,
                schematic_mimetype TEXT,
                target_simulator TEXT NOT NULL DEFAULT 'matlab_simscape',
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            )
            """)

            # Analysis Jobs table
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS jobs (
                id TEXT PRIMARY KEY,
                project_id TEXT NOT NULL,
                type TEXT NOT NULL,
                status TEXT NOT NULL,
                stage TEXT NOT NULL,
                progress INTEGER NOT NULL DEFAULT 0,
                logs TEXT NOT NULL DEFAULT '[]',
                error TEXT,
                created_at TEXT NOT NULL,
                completed_at TEXT,
                FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
            )
            """)

            # Circuit IR table
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS circuit_ir (
                project_id TEXT PRIMARY KEY,
                version TEXT NOT NULL DEFAULT '0.1',
                ir_json TEXT NOT NULL,
                validation_json TEXT,
                updated_at TEXT NOT NULL,
                FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
            )
            """)

            # Generated Models table
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS generated_models (
                id TEXT PRIMARY KEY,
                project_id TEXT NOT NULL,
                target TEXT NOT NULL,
                status TEXT NOT NULL,
                slx_filename TEXT,
                slx_path TEXT,
                script_filename TEXT,
                script_path TEXT,
                compilation_report TEXT,
                created_at TEXT NOT NULL,
                FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
            )
            """)

            conn.commit()
            conn.close()

    # --- Project Operations ---

    def create_project(self, project_id: str, name: str, description: Optional[str] = None, target_simulator: str = "matlab_simscape") -> Dict[str, Any]:
        now = datetime.utcnow().isoformat()
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute(
                """
                INSERT INTO projects (id, name, description, status, target_simulator, created_at, updated_at)
                VALUES (?, ?, ?, 'created', ?, ?, ?)
                """,
                (project_id, name, description, target_simulator, now, now)
            )
            conn.commit()
            conn.close()
        return self.get_project(project_id)

    def get_project(self, project_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM projects WHERE id = ?", (project_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        return dict(row)

    def list_projects(self) -> List[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM projects ORDER BY updated_at DESC")
        rows = cursor.fetchall()
        conn.close()
        return [dict(r) for r in rows]

    def update_project(self, project_id: str, **kwargs) -> Optional[Dict[str, Any]]:
        if not kwargs:
            return self.get_project(project_id)
        kwargs["updated_at"] = datetime.utcnow().isoformat()
        fields = ", ".join(f"{k} = ?" for k in kwargs.keys())
        values = list(kwargs.values()) + [project_id]
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute(f"UPDATE projects SET {fields} WHERE id = ?", values)
            conn.commit()
            conn.close()
        return self.get_project(project_id)

    def delete_project(self, project_id: str) -> bool:
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM projects WHERE id = ?", (project_id,))
            deleted = cursor.rowcount > 0
            conn.commit()
            conn.close()
        return deleted

    # --- Job Operations ---

    def create_job(self, job_id: str, project_id: str, job_type: str = "analyze") -> Dict[str, Any]:
        now = datetime.utcnow().isoformat()
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute(
                """
                INSERT INTO jobs (id, project_id, type, status, stage, progress, logs, created_at)
                VALUES (?, ?, ?, 'processing', 'queued', 0, '[]', ?)
                """,
                (job_id, project_id, job_type, now)
            )
            conn.commit()
            conn.close()
        return self.get_job(job_id)

    def update_job(self, job_id: str, status: Optional[str] = None, stage: Optional[str] = None,
                   progress: Optional[int] = None, log_entry: Optional[str] = None, error: Optional[str] = None):
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT logs FROM jobs WHERE id = ?", (job_id,))
            row = cursor.fetchone()
            logs = json.loads(row["logs"]) if row and row["logs"] else []
            if log_entry:
                timestamp = datetime.utcnow().strftime("%H:%M:%S")
                logs.append(f"[{timestamp}] {log_entry}")

            updates = ["logs = ?"]
            values = [json.dumps(logs)]

            if status is not None:
                updates.append("status = ?")
                values.append(status)
                if status in ("completed", "failed"):
                    updates.append("completed_at = ?")
                    values.append(datetime.utcnow().isoformat())
            if stage is not None:
                updates.append("stage = ?")
                values.append(stage)
            if progress is not None:
                updates.append("progress = ?")
                values.append(progress)
            if error is not None:
                updates.append("error = ?")
                values.append(error)

            values.append(job_id)
            cursor.execute(f"UPDATE jobs SET {', '.join(updates)} WHERE id = ?", values)
            conn.commit()
            conn.close()

    def get_job(self, job_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM jobs WHERE id = ?", (job_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        res = dict(row)
        res["logs"] = json.loads(res.get("logs") or "[]")
        return res

    def get_latest_project_job(self, project_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM jobs WHERE project_id = ? ORDER BY created_at DESC LIMIT 1", (project_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        res = dict(row)
        res["logs"] = json.loads(res.get("logs") or "[]")
        return res

    # --- Circuit IR Operations ---

    def save_circuit_ir(self, project_id: str, ir_dict: Dict[str, Any], validation_dict: Optional[Dict[str, Any]] = None):
        now = datetime.utcnow().isoformat()
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute(
                """
                INSERT INTO circuit_ir (project_id, version, ir_json, validation_json, updated_at)
                VALUES (?, ?, ?, ?, ?)
                ON CONFLICT(project_id) DO UPDATE SET
                    version = excluded.version,
                    ir_json = excluded.ir_json,
                    validation_json = excluded.validation_json,
                    updated_at = excluded.updated_at
                """,
                (
                    project_id,
                    ir_dict.get("version", "0.1"),
                    json.dumps(ir_dict),
                    json.dumps(validation_dict) if validation_dict else None,
                    now
                )
            )
            cursor.execute("UPDATE projects SET updated_at = ? WHERE id = ?", (now, project_id))
            conn.commit()
            conn.close()

    def clear_project_analysis(self, project_id: str):
        """Clears all cached analysis, circuit IR, and generated models for a project so fresh analysis runs."""
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM circuit_ir WHERE project_id = ?", (project_id,))
            cursor.execute("DELETE FROM generated_models WHERE project_id = ?", (project_id,))
            cursor.execute("DELETE FROM jobs WHERE project_id = ?", (project_id,))
            cursor.execute("UPDATE projects SET status = 'schematic_uploaded' WHERE id = ?", (project_id,))
            conn.commit()
            conn.close()

    def get_circuit_ir(self, project_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT ir_json FROM circuit_ir WHERE project_id = ?", (project_id,))
        row = cursor.fetchone()
        conn.close()
        if not row or not row["ir_json"]:
            return None
        return json.loads(row["ir_json"])

    def get_validation(self, project_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT validation_json FROM circuit_ir WHERE project_id = ?", (project_id,))
        row = cursor.fetchone()
        conn.close()
        if not row or not row["validation_json"]:
            return None
        return json.loads(row["validation_json"])

    # --- Generated Models Operations ---

    def save_generated_model(self, model_id: str, project_id: str, target: str, status: str,
                             slx_filename: Optional[str] = None, slx_path: Optional[str] = None,
                             script_filename: Optional[str] = None, script_path: Optional[str] = None,
                             compilation_report: Optional[Dict[str, Any]] = None):
        now = datetime.utcnow().isoformat()
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            cursor.execute(
                """
                INSERT INTO generated_models (id, project_id, target, status, slx_filename, slx_path, script_filename, script_path, compilation_report, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    model_id,
                    project_id,
                    target,
                    status,
                    slx_filename,
                    slx_path,
                    script_filename,
                    script_path,
                    json.dumps(compilation_report or {}),
                    now
                )
            )
            conn.commit()
            conn.close()

    def update_generated_model(self, model_id: str, **kwargs):
        if not kwargs:
            return None
        with self._lock:
            conn = self.get_connection()
            cursor = conn.cursor()
            if "compilation_report" in kwargs and isinstance(kwargs["compilation_report"], dict):
                kwargs["compilation_report"] = json.dumps(kwargs["compilation_report"])
            fields = ", ".join(f"{k} = ?" for k in kwargs.keys())
            values = list(kwargs.values()) + [model_id]
            cursor.execute(f"UPDATE generated_models SET {fields} WHERE id = ?", values)
            conn.commit()
            conn.close()

    def get_latest_generated_model(self, project_id: str) -> Optional[Dict[str, Any]]:
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM generated_models WHERE project_id = ? ORDER BY created_at DESC LIMIT 1", (project_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        res = dict(row)
        res["compilation_report"] = json.loads(res.get("compilation_report") or "{}")
        return res


db = Database()
