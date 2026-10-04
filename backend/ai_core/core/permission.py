
from fastapi import Depends, HTTPException, status
from core.dependencies import get_current_user


def require_project(project: str):
    async def check_project(
        user: dict = Depends(get_current_user),
    ):
        allowed_projects = user.get("projects", [])

        if project not in allowed_projects:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"You do not have access to the {project} project",
            )

        return user

    return check_project

