from app.services.weather_service import (
    get_current_weather
)


async def get_weather_controller(
    lat: float,
    lon: float
):

    weather = await get_current_weather(
        lat,
        lon
    )

    return weather