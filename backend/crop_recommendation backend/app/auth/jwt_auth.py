
from jose import jwt, JWTError

from app.config.settings import settings


def verify_access_token(token: str) -> dict | None:
    """
    Verify a Core-issued JWT and validate its claims.
    """

    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM],
        )

        user_id = payload.get("sub")
        projects = payload.get("projects", [])

        if not isinstance(user_id, str) or not user_id:
            return None

        if not isinstance(projects, list) or not all(
            isinstance(project, str) for project in projects
        ):
            return None

        return payload

    except JWTError:
        return None
