from google.oauth2 import id_token
from google.auth.transport import requests
from fastapi import HTTPException

from app.config.settings import settings


def verify_google_token(token: str):
    """
    Verify Google ID Token and return user information.
    """

    try:
        user_info = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            settings.GOOGLE_CLIENT_ID
        )

        return user_info

    except ValueError:
        raise HTTPException(
            status_code=401,
            detail="Invalid Google ID Token"
        )