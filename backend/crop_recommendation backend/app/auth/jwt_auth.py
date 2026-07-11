from jose import jwt, JWTError

from app.config.settings import settings


def verify_access_token(token: str):
    """
    Verify JWT token and return payload.
    """

    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM]
        )

        return payload

    except JWTError:
        return None