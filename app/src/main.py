from fastapi import FastAPI
from datetime import datetime, timezone

app = FastAPI(
    title="DevOpsForge API",
    description="Cloud-native application for the DevOpsForge platform",
    version="1.0.0",
)


@app.get("/")
def root():
    return {
        "service": "DevOpsForge API",
        "version": "1.0.0",
        "message": "Cloud-native DevOps platform is running",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "devopsforge-api",
    }


@app.get("/api/v1/status")
def status():
    return {
        "status": "running",
        "environment": "development",
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/api/v1/info")
def info():
    return {
        "application": "DevOpsForge",
        "service": "cloud-native-api",
        "version": "1.0.0",
    }
