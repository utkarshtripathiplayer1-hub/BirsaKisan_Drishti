import httpx
import logging
from app.auth.config import AI_CORE_URL

logger = logging.getLogger("crop_backend")


class AICoreService:
    async def get_location(self, token: str):
        try:
            async with httpx.AsyncClient(timeout=5) as client:
                response = await client.get(
                    f"{AI_CORE_URL}/profile/crop",
                    headers={"Authorization": f"Bearer {token}"},
                )
            if response.status_code != 200:
                logger.warning(f"ai_core returned {response.status_code} for location")
                return None
            return response.json().get("location")

        except httpx.TimeoutException:
            logger.warning("ai_core location request timed out")
            return None
        except httpx.RequestError as e:
            logger.error(f"ai_core unreachable: {e}")
            return None


ai_core_service = AICoreService()
