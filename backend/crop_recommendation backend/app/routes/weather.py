from fastapi import APIRouter

from app.controllers.weather_controller import (
    get_weather_controller
)

router = APIRouter(
    prefix="/weather",
    tags=["Weather"]
)


@router.get("/current")
async def current_weather(
    lat: float,
    lon: float
):
    return await get_weather_controller(
        lat,
        lon
    )