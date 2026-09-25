"""Circuit2Sim Backend FastAPI Application Entry Point."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from circuit2sim.backend.app.api.routes import router
from circuit2sim.backend.app.core.config import settings

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="SaaS Backend for converting electrical schematics into native editable MATLAB/Simulink models."
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all during development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Static file serving for uploaded schematics and generated models
app.mount("/uploads", StaticFiles(directory=str(settings.UPLOADS_DIR)), name="uploads")
app.mount("/generated", StaticFiles(directory=str(settings.GENERATED_DIR)), name="generated")

# Include API routes
app.include_router(router)


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "Circuit2Sim API",
        "version": settings.VERSION,
        "engine": "OpenCV + Universal Circuit IR + MATLAB Simscape Compiler"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("circuit2sim.backend.app.main:app", host=settings.HOST, port=settings.PORT, reload=True)
