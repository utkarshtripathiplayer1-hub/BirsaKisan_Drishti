from bson import ObjectId

from core.google_auth import verify_google_token
from core.jwt import create_access_token
from db.user_repository import UserRepository


class AuthService:

    @staticmethod
    async def google_login(id_token: str):

        # Verify Google ID Token
        google_user = verify_google_token(id_token)

        # Find user
        user = await UserRepository.get_by_google_id(
            google_user["google_id"]
        )

        is_new_user = False

        # Create new user
        if user is None:

            is_new_user = True

            user = await UserRepository.create_user(
                {
                    "google_id": google_user["google_id"],
                    "name": google_user["name"],
                    "email": google_user["email"],
                    "picture": google_user["picture"],
                    "preferred_language": "English"
                }
            )

        # Existing user
        else:

            user = await UserRepository.update_user(
                google_user["google_id"],
                {
                    "name": google_user["name"],
                    "email": google_user["email"],
                    "picture": google_user["picture"]
                }
            )

        # Generate JWT
        access_token = create_access_token(str(user["_id"]))

        return {
            "access_token": access_token,
            "user": {
                "id": str(user["_id"]),
                "name": user["name"],
                "email": user["email"],
                "picture": user["picture"],
                "preferred_language": user["preferred_language"]
            },
            "is_new_user": is_new_user
        }
    @staticmethod
    async def update_language(user_id: str, language: str):

        await UserRepository.update_language(
            user_id,
            language
        )

        return {
            "message": "Language updated successfully"
        }