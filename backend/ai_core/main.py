import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from db.mongo import ping_database, client, create_indexes
from core.config import ALLOWED_ORIGINS  # add this to config (see notes)

from api.chat import router as chat_router
from api.auth import router as auth_router
from api.conversations import router as conversation_router
from api.voice import router as voice_router
from api.crop_profile import router as crop_profile_router
from api.account import router as account_router
from api.feedback import router as feedback_router

# ---- Logging (one place, replaces all print statements) ----
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("ai_core")


# ---- Lifespan: startup + shutdown ----
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    try:
        await ping_database()
        await create_indexes()
        logger.info("Startup complete: MongoDB connected,indexes fixed")
    except Exception as e:
        logger.error(f"Startup failed — cannot reach MongoDB: {e}")
        raise  # fail fast: don't serve a broken app
    yield
    # Shutdown
    client.close()
    logger.info("Shutdown complete: MongoDB connection closed")


app = FastAPI(
    title="Birsakisan AI Core",
    version="1.0.0",
    lifespan=lifespan,
)

# ---- CORS: lock to real origins in production ----
app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,   # NOT ["*"] with credentials — see notes
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---- Global exception handler: clean JSON, logged, no stack traces leaked ----
@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled error on {request.method} {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error. Please try again."},
    )


# ---- Health check: required for Render + load balancers ----
@app.get("/health", tags=["system"])
async def health_check():
    try:
        await ping_database()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return JSONResponse(
            status_code=503,
            content={"status": "unhealthy", "database": "disconnected"},
        )


# ---- Routers ----
app.include_router(auth_router)
app.include_router(chat_router)
app.include_router(conversation_router)
app.include_router(voice_router)
app.include_router(crop_profile_router)
app.include_router(account_router)
app.include_router(feedback_router)
