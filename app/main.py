from fastapi import FastAPI
from fastapi.responses import JSONResponse
from datetime import datetime, UTC

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

@app.get("/health")
def health_check():
    """
    Health check endpoint returning service status and current timestamp.
    """
    return JSONResponse(
        status_code=200,
        content={
            "status": "ok",
            "timestamp": datetime.now(UTC).isoformat() + "Z"
        }
    )
