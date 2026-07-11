from fastapi import APIRouter, Depends

from schemas.auth import (
    GoogleLoginRequest,
    GoogleLoginResponse,
    MeResponse,
)
from services.auth_service import AuthService
from core.dependencies import get_current_user
from schemas.auth import (
    UpdateLanguageRequest,
    MessageResponse,
)

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


@router.post(
    "/google",
    response_model=GoogleLoginResponse
)
async def google_login(request: GoogleLoginRequest):
    return await AuthService.google_login(request.id_token)


@router.get(
    "/me",
    response_model=MeResponse
)
async def get_me(
    current_user=Depends(get_current_user)
):
    return {
        "user": {
            "id": str(current_user["_id"]),
            "name": current_user["name"],
            "email": current_user["email"],
            "picture": current_user.get("picture"),
            "preferred_language": current_user["preferred_language"]
        }
    }

@router.patch(
    "/language",
    response_model=MessageResponse
)
async def update_language(
    request: UpdateLanguageRequest,
    current_user=Depends(get_current_user)
):

    return await AuthService.update_language(
        str(current_user["_id"]),
        request.preferred_language
    )