import logging
from typing import Any, Optional

import httpx

from core.config import (
    CROP_BACKEND_URL,
    OPENWEATHER_API_KEY,
)


logger = logging.getLogger("ai_core.context")


class ContextServiceError(Exception):
    """Raised when a context provider fails."""


# ============================================================
# Context keys
# ============================================================

CONTEXT_CROP_RECOMMENDATION = "crop_recommendation"
CONTEXT_DISEASE_DETECTION = "disease_detection"
CONTEXT_CROP_PROFILE = "crop_profile"
CONTEXT_WEATHER = "weather"


# ============================================================
# Crop backend endpoint
# ============================================================

USER_CONTEXT_ENDPOINT = "/ai/user-context"


# ============================================================
# Context Service
# ============================================================

class ContextService:
    """
    Collects trusted information for the AI chatbot.

    Sources:

        1. Crop backend
           - latest crop recommendation
           - latest disease detection

        2. OpenWeather
           - current weather

        3. Explicit application context
           - crop recommendation
           - disease detection
           - crop profile

    Bee monitoring data is intentionally NOT connected yet.
    """

    def __init__(
        self,
        crop_backend_url: str = CROP_BACKEND_URL,
    ):
        self.crop_backend_url = (
            crop_backend_url.rstrip("/")
            if crop_backend_url
            else ""
        )

    # ========================================================
    # Main context builder
    # ========================================================

    async def build_context(
        self,
        *,
        user_id: Optional[str] = None,
        access_token: Optional[str] = None,
        domain: Optional[str] = None,
        intent: Optional[str] = None,
        crop_recommendation: Optional[dict] = None,
        disease_detection: Optional[dict] = None,
        crop_profile: Optional[dict] = None,
        latitude: Optional[float] = None,
        longitude: Optional[float] = None,
        include_weather: bool = False,
    ) -> dict[str, Any]:

        context: dict[str, Any] = {}

        # ----------------------------------------------------
        # Basic chatbot information
        # ----------------------------------------------------

        if domain:
            context["domain"] = domain

        if intent:
            context["intent"] = intent

        # ----------------------------------------------------
        # Get trusted crop/disease data from crop backend
        # ----------------------------------------------------

        backend_context = None

        if user_id and access_token:

            backend_context = (
                await self.get_crop_backend_context(
                    access_token=access_token
                )
            )

        if backend_context:

            last_detection = (
                backend_context.get(
                    "last_detection"
                )
            )

            last_recommendation = (
                backend_context.get(
                    "last_recommendation"
                )
            )

            if last_detection is not None:

                context[
                    CONTEXT_DISEASE_DETECTION
                ] = self._sanitize_context(
                    last_detection
                )

            if last_recommendation is not None:

                context[
                    CONTEXT_CROP_RECOMMENDATION
                ] = self._sanitize_context(
                    last_recommendation
                )

        # ----------------------------------------------------
        # Explicit context from frontend
        #
        # Only use it if backend context did not already
        # provide the corresponding trusted information.
        # ----------------------------------------------------

        if (
            CONTEXT_CROP_RECOMMENDATION not in context
            and crop_recommendation is not None
        ):

            context[
                CONTEXT_CROP_RECOMMENDATION
            ] = self._sanitize_context(
                crop_recommendation
            )

        if (
            CONTEXT_DISEASE_DETECTION not in context
            and disease_detection is not None
        ):

            context[
                CONTEXT_DISEASE_DETECTION
            ] = self._sanitize_context(
                disease_detection
            )

        # ----------------------------------------------------
        # Crop profile
        # ----------------------------------------------------

        if crop_profile is not None:

            context[
                CONTEXT_CROP_PROFILE
            ] = self._sanitize_context(
                crop_profile
            )

        # ----------------------------------------------------
        # Current weather
        # ----------------------------------------------------

        if include_weather:

            weather = await self.get_weather(
                latitude=latitude,
                longitude=longitude,
            )

            if weather is not None:

                context[
                    CONTEXT_WEATHER
                ] = weather

        return context

    # ========================================================
    # Crop Backend
    # ========================================================

    async def get_crop_backend_context(
        self,
        *,
        access_token: str,
    ) -> Optional[dict]:
        """
        Fetch the authenticated farmer's latest crop
        recommendation and disease detection.

        Crop backend endpoint:

            GET /ai/user-context

        Authentication:

            Bearer JWT
        """

        if not self.crop_backend_url:

            logger.warning(
                "CROP_BACKEND_URL is not configured."
            )

            return None

        url = (
            f"{self.crop_backend_url}"
            f"{USER_CONTEXT_ENDPOINT}"
        )

        headers = {
            "Authorization": f"Bearer {access_token}",
            "Accept": "application/json",
        }

        try:

            async with httpx.AsyncClient(
                timeout=15.0
            ) as http_client:

                response = await http_client.get(
                    url,
                    headers=headers,
                )

        except httpx.RequestError as exc:

            logger.error(
                "Crop backend request failed: %s",
                exc,
            )

            return None

        # ----------------------------------------------------
        # No context for this farmer
        # ----------------------------------------------------

        if response.status_code == 404:

            logger.info(
                "No crop/disease context found for farmer."
            )

            return None

        # ----------------------------------------------------
        # Authentication failure
        # ----------------------------------------------------

        if response.status_code in (
            401,
            403,
        ):

            logger.error(
                "Crop backend authentication failed."
            )

            return None

        # ----------------------------------------------------
        # Other backend failures
        # ----------------------------------------------------

        if response.status_code != 200:

            logger.error(
                "Crop backend returned %s: %s",
                response.status_code,
                response.text[:500],
            )

            return None

        # ----------------------------------------------------
        # Parse JSON
        # ----------------------------------------------------

        try:

            data = response.json()

        except ValueError:

            logger.error(
                "Crop backend returned invalid JSON."
            )

            return None

        if not isinstance(data, dict):

            logger.error(
                "Crop backend context has invalid format."
            )

            return None

        return data

    # ========================================================
    # Weather
    # ========================================================

    async def get_weather(
        self,
        *,
        latitude: Optional[float],
        longitude: Optional[float],
    ) -> Optional[dict]:
        """
        Get current weather from OpenWeather.

        Missing coordinates or API failures return None.

        The chatbot must never invent weather data.
        """

        if not OPENWEATHER_API_KEY:

            logger.warning(
                "OpenWeather API key is not configured."
            )

            return None

        if latitude is None or longitude is None:

            logger.warning(
                "Weather requested but coordinates are missing."
            )

            return None

        url = (
            "https://api.openweathermap.org/"
            "data/2.5/weather"
        )

        params = {
            "lat": latitude,
            "lon": longitude,
            "appid": OPENWEATHER_API_KEY,
            "units": "metric",
        }

        try:

            async with httpx.AsyncClient(
                timeout=10.0
            ) as http_client:

                response = await http_client.get(
                    url,
                    params=params,
                )

        except httpx.RequestError as exc:

            logger.error(
                "OpenWeather request failed: %s",
                exc,
            )

            return None

        if response.status_code != 200:

            logger.error(
                "OpenWeather returned status %s",
                response.status_code,
            )

            return None

        try:

            data = response.json()

        except ValueError:

            logger.error(
                "OpenWeather returned invalid JSON."
            )

            return None

        return self._format_weather(
            data
        )

    # ========================================================
    # Weather formatting
    # ========================================================

    @staticmethod
    def _format_weather(
        data: dict,
    ) -> dict:

        main = data.get(
            "main",
            {},
        )

        wind = data.get(
            "wind",
            {},
        )

        weather_list = data.get(
            "weather",
            [],
        )

        weather_description = None

        if weather_list:

            weather_description = (
                weather_list[0].get(
                    "description"
                )
            )

        return {
            "location": data.get(
                "name"
            ),
            "temperature_c": main.get(
                "temp"
            ),
            "feels_like_c": main.get(
                "feels_like"
            ),
            "humidity_percent": main.get(
                "humidity"
            ),
            "pressure_hpa": main.get(
                "pressure"
            ),
            "weather": weather_description,
            "wind_speed_mps": wind.get(
                "speed"
            ),
            "cloud_percent": data.get(
                "clouds",
                {},
            ).get(
                "all"
            ),
            "visibility_meters": data.get(
                "visibility"
            ),
        }

    # ========================================================
    # Context sanitization
    # ========================================================

    @staticmethod
    def _sanitize_context(
        data: Any,
    ) -> Any:

        if isinstance(data, dict):

            blocked_keys = {
                "password",
                "password_hash",
                "token",
                "access_token",
                "refresh_token",
                "api_key",
                "secret",
                "jwt",
                "_access_token",
            }

            return {
                key: ContextService._sanitize_context(
                    value
                )
                for key, value in data.items()
                if key.lower() not in blocked_keys
            }

        if isinstance(data, list):

            return [
                ContextService._sanitize_context(
                    item
                )
                for item in data
            ]

        return data


# ============================================================
# Context availability helpers
# ============================================================

def has_context(
    context: dict,
    key: str,
) -> bool:

    value = context.get(key)

    return value is not None


# ============================================================
# Default service instance
# ============================================================

context_service = ContextService()