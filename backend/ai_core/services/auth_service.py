from fastapi import HTTPException, status

from core.google_auth import verify_google_token
from core.jwt import create_access_token
from db.user_repository import UserRepository


class AuthService:

    @staticmethod
    async def google_login(id_token: str, app_type: str):
        if app_type not in ("beehive", "agriculture"):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid app_type"
            )

        google_user = verify_google_token(id_token)

        user = await UserRepository.get_by_google_id(
            google_user["google_id"]
        )

        is_new_account = user is None

        if is_new_account:
            user = await UserRepository.create_user({
                "google_id": google_user["google_id"],
                "name": google_user["name"],
                "email": google_user["email"],
                "picture": google_user.get("picture"),
                "preferred_language": "English",
                "new_user_beehive": True,
                "new_user_agriculture": True,
                "setup_completed_beehive": False,
                "setup_completed_agriculture": False
            })

        # Ensure older accounts have the new fields
        defaults = {
            "new_user_beehive": True,
            "new_user_agriculture": True,
            "setup_completed_beehive": False,
            "setup_completed_agriculture": False
        }

        for field, default in defaults.items():
            user.setdefault(field, default)

        new_user_field = f"new_user_{app_type}"

        # Capture first-login status before updating it
        is_new_for_app = user[new_user_field]

        # Update profile and mark this app as previously accessed
        updated_user = await UserRepository.update_user(
            google_user["google_id"],
            {
                "name": google_user["name"],
                "email": google_user["email"],
                "picture": google_user.get("picture"),
                **defaults,
                new_user_field: False
            }
        )

        if updated_user is None:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Unable to update user"
            )

        # Generate JWT containing the user's identity
        access_token = create_access_token(
            user_id=str(updated_user["_id"])
        )

        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": {
                "id": str(updated_user["_id"]),
                "name": updated_user["name"],
                "email": updated_user["email"],
                "picture": updated_user.get("picture"),
                "preferred_language": updated_user.get(
                    "preferred_language", "English"
                ),
                "new_user_beehive": (
                    is_new_for_app
                    if app_type == "beehive"
                    else updated_user["new_user_beehive"]
                ),
                "new_user_agriculture": (
                    is_new_for_app
                    if app_type == "agriculture"
                    else updated_user["new_user_agriculture"]
                ),
                "setup_completed_beehive": updated_user[
                    "setup_completed_beehive"
                ],
                "setup_completed_agriculture": updated_user[
                    "setup_completed_agriculture"
                ]
            }
        }

    @staticmethod
    async def update_language(user_id: str, language: str):
        await UserRepository.update_language(user_id, language)

        return {
            "message": "Language updated successfully"
        }

    
    @staticmethod
    async def complete_setup(user_id: str, app_type: str):
        if app_type not in ("beehive", "agriculture"):
            raise HTTPException(
                status_code=400,
                detail="Invalid app_type"
            )

        user = await UserRepository.mark_setup_completed(
            user_id=user_id,
            app_type=app_type
        )

        if user is None:
            raise HTTPException(
                status_code=404,
                detail="User not found"
            )

        setup_field = f"setup_completed_{app_type}"

        return {
            "message": f"{app_type.capitalize()} setup completed successfully",
            setup_field: user.get(setup_field, False)
        }

