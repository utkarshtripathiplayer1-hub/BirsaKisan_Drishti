import httpx

from app.config.settings import settings
from app.repositories.weather_repository import weather_repository


async def get_current_weather(
    lat: float,
    lon: float
):
    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?lat={lat}"
        f"&lon={lon}"
        f"&appid={settings.OPENWEATHER_API_KEY}"
        f"&units=metric"
    )

    async with httpx.AsyncClient() as client:
        response = await client.get(url)

    data = response.json()

    # Handle API errors
    if response.status_code != 200:
        return {
            "error": data.get(
                "message",
                "Weather API Error"
            )
        }

    result = {
        "latitude": lat,
        "longitude": lon,

        "city": data["name"],

        "temperature": data["main"]["temp"],

        "humidity": data["main"]["humidity"],

        "condition": data["weather"][0]["main"],

        "description": data["weather"][0]["description"],

        "wind_speed": data["wind"]["speed"],

        "pressure": data["main"]["pressure"],

        "feels_like": data["main"]["feels_like"]
    }

    # Save weather data into MongoDB
    weather_id = await weather_repository.save(
        result.copy()
    )

    result["weather_id"] = weather_id

    return result


class WeatherService:

    async def current_weather(
        self,
        lat: float,
        lon: float
    ):
        return await get_current_weather(
            lat,
            lon
        )


weather_service = WeatherService()


