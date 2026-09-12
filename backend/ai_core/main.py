import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from db.mongo import (
    ping_database,
    client,
    create_indexes,
)

from api.chats import router as conversations_router
from api.auth import router as auth_router
from api.chat import router as chat_router
from api.voice import router as voice_router
from api.crop_profile import router as crop_profile_router
from api.account import router as account_router
from api.feedback import router as feedback_router
from api.bhashini import router as bhashini_router


# ============================================================
# LOGGING
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

logger = logging.getLogger("ai_core")


# ============================================================
# LIFESPAN
# ============================================================

@asynccontextmanager
async def lifespan(app: FastAPI):

    # --------------------------------------------------------
    # STARTUP
    # --------------------------------------------------------

    try:

        await ping_database()

        await create_indexes()

        logger.info(
            "Startup complete: MongoDB connected, indexes fixed"
        )

    except Exception as e:

        logger.error(
            f"Startup failed — cannot reach MongoDB: {e}"
        )

        # Do not start the application if database
        # connection fails.
        raise

    yield

    # --------------------------------------------------------
    # SHUTDOWN
    # --------------------------------------------------------

    client.close()

    logger.info(
        "Shutdown complete: MongoDB connection closed"
    )


# ============================================================
# FASTAPI APPLICATION
# ============================================================

app = FastAPI(
    title="Birsakisan AI Core",
    version="1.0.0",
    lifespan=lifespan,
)


# ============================================================
# CORS
# ============================================================

# Temporary production configuration.
#
# This allows the Flutter/web frontend to communicate
# with the backend while we complete deployment.
#
# credentials=False is intentional because "*" cannot
# safely be combined with credentialed CORS requests.

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# GLOBAL EXCEPTION HANDLER
# ============================================================

@app.exception_handler(Exception)
async def unhandled_exception_handler(
    request: Request,
    exc: Exception,
):

    logger.error(
        f"Unhandled error on "
        f"{request.method} "
        f"{request.url.path}: "
        f"{exc}",
        exc_info=True,
    )

    return JSONResponse(
        status_code=500,
        content={
            "detail": (
                "Internal server error. "
                "Please try again."
            )
        },
    )


# ============================================================
# HEALTH CHECK
# ============================================================

@app.get(
    "/health",
    tags=["system"],
)
async def health_check():

    try:

        await ping_database()

        return {
            "status": "healthy",
            "database": "connected",
        }

    except Exception as e:

        logger.error(
            f"Health check failed: {e}"
        )

        return JSONResponse(
            status_code=503,
            content={
                "status": "unhealthy",
                "database": "disconnected",
            },
        )


# ============================================================
# ROUTERS
# ============================================================

# Authentication
app.include_router(
    auth_router
)


# Text chat + conversations
app.include_router(
    chat_router
)


# Voice
app.include_router(
    voice_router
)


# Crop profile
app.include_router(
    crop_profile_router
)


# Account
app.include_router(
    account_router
)


# Feedback
app.include_router(
    feedback_router
)


# Bhashini
app.include_router(
    bhashini_router
)


# Conversation-related endpoints
app.include_router(
    conversations_router
)