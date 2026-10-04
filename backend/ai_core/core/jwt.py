
from datetime import datetime, timedelta, timezone

from jose import jwt, JWTError

from core.config import (
    JWT_SECRET_KEY,
    JWT_ALGORITHM,
    JWT_EXPIRE_MINUTES,
)


def create_access_token(
    user_id: str,
    projects: list[str] | None = None,
) -> str:
    """
    Create a JWT access token for an authenticated user.

    Args:
        user_id: MongoDB user ID as a string.
        projects: List of authorized projects, e.g. ["bee", "crop"].

    Returns:
        Encoded JWT access token.
    """

    now = datetime.now(timezone.utc)
    expire = now + timedelta(minutes=JWT_EXPIRE_MINUTES)

    payload = {
        "sub": user_id,
        "projects": projects or [],
        "iat": now,
        "exp": expire,
    }

    access_token = jwt.encode(
        payload,
        JWT_SECRET_KEY,
        algorithm=JWT_ALGORITHM,
    )

    return access_token


def verify_access_token(token: str) -> dict | None:
    """
    Verify a JWT access token and return its payload.

    Args:
        token: Encoded JWT access token.

    Returns:
        Decoded JWT payload if valid, otherwise None.
    """

    try:
        payload = jwt.decode(
            token,
            JWT_SECRET_KEY,
            algorithms=[JWT_ALGORITHM],
        )

        user_id = payload.get("sub")
        projects = payload.get("projects", [])

        if not user_id or not isinstance(user_id, str):
            return None

        if not isinstance(projects, list):
            return None

        if not all(
            isinstance(project, str)
            for project in projects
        ):
            return None

        return payload

    except JWTError:
        return None

