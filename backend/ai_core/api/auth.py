
from fastapi import APIRouter, Depends

from schemas.auth import (
    GoogleLoginRequest,
    GoogleLoginResponse,
    MeResponse,
    UpdateLanguageRequest,
    MessageResponse,
    SetupCompletedRequest,
    SetupCompletedResponse,
)
from services.auth_service import AuthService
from core.dependencies import get_current_user

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


@router.post(
    "/google",
    response_model=GoogleLoginResponse
)
async def google_login(request: GoogleLoginRequest):
    return await AuthService.google_login(
        id_token=request.id_token,
        app_type=request.app_type.value
    )


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
            "preferred_language": current_user.get(
                "preferred_language", "English"
            ),
            "new_user_beehive": current_user.get(
                "new_user_beehive", True
            ),
            "new_user_agriculture": current_user.get(
                "new_user_agriculture", True
            ),
            "setup_completed_beehive": current_user.get(
                "setup_completed_beehive", False
            ),
            "setup_completed_agriculture": current_user.get(
                "setup_completed_agriculture", False
            )
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


@router.post(
    "/setup-completed",
    response_model=SetupCompletedResponse
)
async def complete_setup(
    request: SetupCompletedRequest,
    current_user=Depends(get_current_user)
):
    return await AuthService.complete_setup(
        user_id=str(current_user["_id"]),
        app_type=request.app_type.value
    )
