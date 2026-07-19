import httpx

from app.auth.config import AI_CORE_URL


class AICoreService:

    async def get_location(
        self,
        token: str
    ):

        async with httpx.AsyncClient() as client:

            response = await client.get(
                f"{AI_CORE_URL}/profile/crop",
                headers={
                    "Authorization": f"Bearer {token}"
                },
                timeout=5
            )


        if response.status_code != 200:
            return None


        data = response.json()


        return data.get("location")



ai_core_service = AICoreService()
