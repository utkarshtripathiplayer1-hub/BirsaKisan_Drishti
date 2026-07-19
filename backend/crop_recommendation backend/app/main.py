import warnings 
warnings.filterwarnings("ignore")

from dotenv import load_dotenv

load_dotenv()
from fastapi import FastAPI
from app.routes.dashboard import router as dashboard_router
from app.routes.weather import router as weather_router
from app.routes.disease import router as disease_router
from app.routes.crop_route import router as crop_router
from app.routes.pdf_route import router as pdf_router
from app.routes.ai import router as ai_router
from fastapi.middleware.cors import CORSMiddleware
from app.routes.rotation_route import (
    router as rotation_router
)
from app.routes.my_farm_route import (
    router as my_farm_router
)
from app.routes.active_crop_route import (
    router as active_crop_router
)

app = FastAPI(
    title = "Crop Backend",
    version = "1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # replace with frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(crop_router)
app.include_router(pdf_router)

app.include_router(
    dashboard_router,
    prefix = "/dashboard",
    tags = ["Dashboard"]
)

app.include_router(weather_router)


app.include_router(
    disease_router
)

app.include_router(
    ai_router,
    prefix="/ai",
    tags=["AI Context"]
)

#CROP ROTATION

app.include_router(rotation_router)


app.include_router(
    my_farm_router
)

app.include_router(
    active_crop_router
)

@app.get("/")
async def root():
    return{"message": "Crop Backend Running"}