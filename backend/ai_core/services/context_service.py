import requests

CROP_BACKEND_URL = "http://127.0.0.1:8000"

def get_user_context(user_id: str):
 
    try:

        response = requests.get(
            f"{CROP_BACKEND_URL}/ai/user-context/{user_id}",
            timeout=5
        )

        if response.status_code == 200:
            return response.json()

        return None

    except Exception as e:
        print("Context Service Error:", e)
        return None

