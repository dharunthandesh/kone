"""Application configuration and settings."""

from pathlib import Path
from typing import List, Set
from pydantic import BaseModel, Field


class Settings(BaseModel):
    PROJECT_NAME: str = "Circuit2Sim"
    VERSION: str = "0.1.0"
    API_PREFIX: str = "/api"

    # Base paths
    BASE_DIR: Path = Path(__file__).resolve().parent.parent.parent.parent
    UPLOADS_DIR: Path = Path(__file__).resolve().parent.parent.parent.parent / "uploads"
    GENERATED_DIR: Path = Path(__file__).resolve().parent.parent.parent.parent / "generated"
    DATABASE_PATH: Path = Path(__file__).resolve().parent.parent.parent.parent / "circuit2sim.db"

    # Server settings
    HOST: str = "127.0.0.1"
    PORT: int = 8000
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:3001",
        "http://127.0.0.1:3001",
    ]

    # File limits
    MAX_UPLOAD_SIZE_MB: int = 25
    ALLOWED_EXTENSIONS: Set[str] = {".png", ".jpg", ".jpeg", ".pdf", ".svg", ".bmp"}


settings = Settings()

# Ensure directories exist
settings.UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
settings.GENERATED_DIR.mkdir(parents=True, exist_ok=True)
