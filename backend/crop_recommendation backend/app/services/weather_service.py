import httpx

from app.config.settings import settings


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

    # HANDLE API ERRORS
    if response.status_code != 200:

        return {
            "error": data.get(
                "message",
                "Weather API Error"
            )
        }

    return {

        "city": data["name"],

        "temperature": data["main"]["temp"],

        "humidity": data["main"]["humidity"],

        "condition": data["weather"][0]["main"],

        "description": data["weather"][0]["description"],

        "wind_speed": data["wind"]["speed"],

        "pressure": data["main"]["pressure"],

        "feels_like": data["main"]["feels_like"]
    }