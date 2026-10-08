from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.weather_controller import get_weather_controller

router = APIRouter(
    prefix="/weather",
    tags=["Weather"],
)


@router.get("/current")
async def current_weather(
    lat: float,
    lon: float,
    current_user: dict = Depends(get_current_user),
):
    return await get_weather_controller(
        lat,
        lon,
    )
