from fastapi import FastAPI
from app.routes.dashboard import router as dashboard_router
from app.routes.weather import router as weather_router
from app.routes.disease import router as disease_router
from app.routes.crop_route import router as crop_router
from app.routes.pdf_route import router as pdf_router
from app.routes.ai import router as ai_router
from fastapi.middleware.cors import CORSMiddleware


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

app.include_router(
    weather_router,
    prefix="/weather",
    tags=["Weather"]
)


app.include_router(
    disease_router
)

app.include_router(
    ai_router,
    prefix="/ai",
    tags=["AI Context"]
)

@app.get("/")
async def root():
    return{"message": "Crop Backend Running"}