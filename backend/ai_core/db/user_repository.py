from datetime import datetime, timezone

from bson import ObjectId
from bson.errors import InvalidId

from db.collections import users


class UserRepository:
    ALLOWED_APPS = {"beehive", "agriculture"}

    @staticmethod
    async def get_by_google_id(google_id: str):
        return await users.find_one({"google_id": google_id})

    @staticmethod
    async def get_by_email(email: str):
        return await users.find_one({"email": email})

    @staticmethod
    async def create_user(user_data: dict):
        now = datetime.now(timezone.utc)

        user_data = user_data.copy()
        user_data["created_at"] = now
        user_data["updated_at"] = now

        # App-specific first-login and setup statuses
        user_data.setdefault("new_user_beehive", True)
        user_data.setdefault("new_user_agriculture", True)
        user_data.setdefault("setup_completed_beehive", False)
        user_data.setdefault("setup_completed_agriculture", False)

        # Remove legacy project permissions
        user_data.pop("projects", None)

        result = await users.insert_one(user_data)

        return await users.find_one({"_id": result.inserted_id})

    @staticmethod
    async def update_user(google_id: str, update_data: dict):
        now = datetime.now(timezone.utc)
        update_data = update_data.copy()
        update_data["updated_at"] = now

        await users.update_one(
            {"google_id": google_id},
            {
                "$set": update_data,
                "$unset": {"projects": ""}
            }
        )

        return await users.find_one({"google_id": google_id})

    @staticmethod
    async def get_by_id(user_id: str):
        try:
            object_id = ObjectId(user_id)
        except (InvalidId, TypeError):
            return None

        return await users.find_one({"_id": object_id})

    @staticmethod
    async def mark_setup_completed(user_id: str, app_type: str):
        if app_type not in UserRepository.ALLOWED_APPS:
            raise ValueError("Invalid app_type")

        setup_field = f"setup_completed_{app_type}"

        try:
            object_id = ObjectId(user_id)
        except (InvalidId, TypeError):
            return None

        await users.update_one(
            {"_id": object_id},
            {
                "$set": {
                    setup_field: True,
                    "updated_at": datetime.now(timezone.utc)
                }
            }
        )

        return await UserRepository.get_by_id(user_id)

    @staticmethod
    async def update_language(user_id: str, language: str):
        try:
            object_id = ObjectId(user_id)
        except (InvalidId, TypeError):
            return None

        return await users.update_one(
            {"_id": object_id},
            {
                "$set": {
                    "preferred_language": language,
                    "updated_at": datetime.now(timezone.utc)
                },
                "$unset": {"projects": ""}
            }
        )

    @staticmethod
    async def delete_user(user_id: str):
        try:
            object_id = ObjectId(user_id)
        except (InvalidId, TypeError):
            return None

        return await users.delete_one({"_id": object_id})
