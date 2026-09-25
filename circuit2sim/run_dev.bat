@echo off
echo ========================================================
echo Starting Circuit2Sim (Backend + Frontend)
echo ========================================================

start "Circuit2Sim Backend" cmd /k "cd /d %~dp0.. && python -m uvicorn circuit2sim.backend.app.main:app --host 127.0.0.1 --port 8000 --reload"

timeout /t 2 >nul

start "Circuit2Sim Frontend" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo Circuit2Sim is starting!
echo Frontend: http://localhost:3000
echo Backend:  http://127.0.0.1:8000
echo Docs:     http://127.0.0.1:8000/docs
echo ========================================================
