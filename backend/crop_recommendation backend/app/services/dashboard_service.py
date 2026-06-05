from app.services.weather_service import (
    get_current_weather
)


async def get_dashboard_data(
    lat: float,
    lon: float
):

    weather = await get_current_weather(
        lat,
        lon
    )

    dashboard_response = {

        "weather": weather,

        "farm_summary": {
            "total_farms": 2,
            "active_crops": 3
        },

        "alerts": [
            "Heavy rain expected tomorrow"
        ]
    }

    return dashboard_response