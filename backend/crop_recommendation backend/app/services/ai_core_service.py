import requests

AI_CORE_URL = "http://127.0.0.1:8002"


class AICoreService:

    def get_location(self, token: str):

        response = requests.get(
            f"{AI_CORE_URL}/profile/crop",
            headers={
                "Authorization": f"Bearer {token}"
            },
            timeout=5
        )

        print("STATUS:", response.status_code)
        print("RESPONSE:", response.text)

        if response.status_code != 200:
            return None

        data = response.json()

        return data.get("location")


ai_core_service = AICoreService()