from jose import jwt, JWTError

from app.config.settings import settings


def verify_access_token(token: str) -> dict | None:
    """
    Verify a Core-issued JWT and validate the user identity claims.
    """

    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM],
        )

        user_id = payload.get("sub")

        if not isinstance(user_id, str) or not user_id:
            return None

        return payload

    except JWTError:
        return None