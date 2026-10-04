
from datetime import datetime, timezone
from bson import ObjectId
from db.collections import users


class UserRepository:
    ALLOWED_PROJECTS = {"bee", "crop"}

    @staticmethod
    async def get_by_google_id(google_id: str):
        return await users.find_one({"google_id": google_id})

    @staticmethod
    async def get_by_email(email: str):
        return await users.find_one({"email": email})

    @staticmethod
    async def create_user(user_data: dict):
        now = datetime.now(timezone.utc)

        user_data["created_at"] = now
        user_data["updated_at"] = now
        user_data.setdefault("projects", [])

        result = await users.insert_one(user_data)
        return await users.find_one({"_id": result.inserted_id})

    @staticmethod
    async def update_user(google_id: str, update_data: dict):
        update_data["updated_at"] = datetime.now(timezone.utc)

        await users.update_one(
            {"google_id": google_id},
            {"$set": update_data}
        )

        return await users.find_one({"google_id": google_id})

    @staticmethod
    async def get_by_id(user_id: str):
        return await users.find_one(
            {"_id": ObjectId(user_id)}
        )

    @staticmethod
    async def set_projects(user_id: str, projects: list[str]):
        allowed = UserRepository.ALLOWED_PROJECTS

        if not set(projects).issubset(allowed):
            raise ValueError("Invalid project specified")

        await users.update_one(
            {"_id": ObjectId(user_id)},
            {
                "$set": {
                    "projects": list(set(projects)),
                    "updated_at": datetime.now(timezone.utc)
                }
            }
        )

        return await UserRepository.get_by_id(user_id)

    @staticmethod
    async def add_project(user_id: str, project: str):
        if project not in UserRepository.ALLOWED_PROJECTS:
            raise ValueError("Invalid project specified")

        await users.update_one(
            {"_id": ObjectId(user_id)},
            {
                "$addToSet": {"projects": project},
                "$set": {"updated_at": datetime.now(timezone.utc)}
            }
        )

        return await UserRepository.get_by_id(user_id)

    @staticmethod
    async def remove_project(user_id: str, project: str):
        if project not in UserRepository.ALLOWED_PROJECTS:
            raise ValueError("Invalid project specified")

        await users.update_one(
            {"_id": ObjectId(user_id)},
            {
                "$pull": {"projects": project},
                "$set": {"updated_at": datetime.now(timezone.utc)}
            }
        )

        return await UserRepository.get_by_id(user_id)

    @staticmethod
    async def update_language(user_id: str, language: str):
        result = await users.update_one(
            {"_id": ObjectId(user_id)},
            {
                "$set": {
                    "preferred_language": language,
                    "updated_at": datetime.now(timezone.utc)
                }
            }
        )

        return result

    @staticmethod
    async def delete_user(user_id: str):
        await users.delete_one(
            {"_id": ObjectId(user_id)}
        )

