import logging
import warnings
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

load_dotenv()

# Narrowed: silence sklearn/pandas noise without hiding your own deprecations
warnings.filterwarnings("ignore", category=UserWarning)
warnings.filterwarnings("ignore", category=FutureWarning)

from app.database.mongodb import ping_database, create_indexes, client
from app.config.settings import ALLOWED_ORIGINS  # add ALLOWED_ORIGINS to settings

# Importing this triggers model loading (models load once at import — verified)
from app.services.crop_service import crop_service

from app.routes.dashboard import router as dashboard_router
from app.routes.weather import router as weather_router
from app.routes.disease import router as disease_router
from app.routes.crop_route import router as crop_router
from app.routes.pdf_route import router as pdf_router
from app.routes.ai import router as ai_router
from app.routes.rotation_route import router as rotation_router
from app.routes.my_farm_route import router as my_farm_router
from app.routes.active_crop_route import router as active_crop_router

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("crop_backend")


@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        await ping_database()
        await create_indexes()
        # Confirm models actually loaded (crop_service import already ran __init__)
        if crop_service.model is None:
            raise RuntimeError("Crop model failed to load")
        logger.info("Startup complete: DB connected, indexes ensured, models loaded")
    except Exception as e:
        logger.error(f"Startup failed: {e}")
        raise
    yield
    client.close()
    logger.info("Shutdown complete: MongoDB connection closed")


app = FastAPI(title="Crop Backend", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled error on {request.method} {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(status_code=500, content={"detail": "Internal server error. Please try again."})


@app.get("/health", tags=["system"])
async def health_check():
    try:
        await ping_database()
        return {"status": "healthy", "database": "connected"}
    except Exception:
        return JSONResponse(status_code=503, content={"status": "unhealthy", "database": "disconnected"})


@app.get("/")
async def root():
    return {"message": "Crop Backend Running"}


app.include_router(crop_router)
app.include_router(pdf_router)
app.include_router(dashboard_router, prefix="/dashboard", tags=["Dashboard"])
app.include_router(weather_router)
app.include_router(disease_router)
app.include_router(ai_router, prefix="/ai", tags=["AI Context"])
app.include_router(rotation_router)
app.include_router(my_farm_router)
app.include_router(active_crop_router)