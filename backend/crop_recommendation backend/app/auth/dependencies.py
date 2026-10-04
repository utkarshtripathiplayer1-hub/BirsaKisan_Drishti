
from fastapi import HTTPException, Depends, status
from fastapi.security import HTTPAuthorizationCredentials

from app.auth.jwt_auth import verify_access_token
from app.auth.security import security


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
) -> dict:
    if credentials is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token missing",
        )

    token = credentials.credentials
    payload = verify_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )

    payload["token"] = token
    return payload


def require_project(project: str):
    async def project_access(
        user: dict = Depends(get_current_user),
    ) -> dict:
        if project not in user.get("projects", []):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"You do not have access to the {project} project",
            )

        return user

    return project_access
