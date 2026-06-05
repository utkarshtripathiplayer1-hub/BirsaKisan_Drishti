from fastapi import FastAPI
from app.routes.dashboard import router as dashboard_router
from app.routes.weather import router as weather_router
from app.routes.crop import router as crop_router


app = FastAPI(
    title = "Crop Backend",
    version = "1.0.0"
)

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

app.include_router(crop_router)



@app.get("/")
async def root():
    return{"message": "Crop Backend Running"}