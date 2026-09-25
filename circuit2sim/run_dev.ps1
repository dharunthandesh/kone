# Circuit2Sim Unified Startup Script
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Starting Circuit2Sim (FastAPI Backend + Next.js Frontend)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Start Backend in new process
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$Root'; python -m uvicorn circuit2sim.backend.app.main:app --host 127.0.0.1 --port 8000 --reload"

Start-Sleep -Seconds 2

# 2. Start Frontend in new process
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot/frontend'; npm run dev"

Write-Host ""
Write-Host "Backend API:  http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "Swagger Docs: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "Frontend App: http://localhost:3000" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
