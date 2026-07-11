from google.oauth2 import id_token
from google.auth.transport import requests

from core.config import GOOGLE_CLIENT_ID


def verify_google_token(token: str):
    """
    Verifies a Google ID token and returns the user's information.
    Raises ValueError if the token is invalid.
    """

    try:
        id_info = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )

        return {
            "google_id": id_info["sub"],
            "email": id_info["email"],
            "name": id_info.get("name"),
            "picture": id_info.get("picture"),
        }

    except Exception as e:
        raise ValueError(f"Invalid Google token: {str(e)}")