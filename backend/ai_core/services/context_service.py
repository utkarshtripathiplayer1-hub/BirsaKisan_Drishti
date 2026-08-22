import requests

from core.config import CROP_BACKEND_URL


def get_user_context(
    user_id: str,
    access_token: str,
):
    try:
        print("Fetching context for user:", user_id)

        headers = {
            "Authorization": f"Bearer {access_token}"
        }

        response = requests.get(
            f"{CROP_BACKEND_URL}/ai/user-context",
            headers=headers,
            timeout=5,
        )

        print(
            "Context response:",
            response.status_code,
            response.text,
        )

        if response.status_code == 200:
            return response.json()

        print(
            "Context fetch failed:",
            response.status_code,
            response.text,
        )

        return None

    except Exception as e:
        print("Context Service Error:", e)
        return None