from datetime import datetime

from db.collections import users
from bson import ObjectId

class UserRepository:

    @staticmethod
    async def get_by_google_id(google_id: str):
        return await users.find_one({"google_id": google_id})

    @staticmethod
    async def get_by_email(email: str):
        return await users.find_one({"email": email})

    @staticmethod
    async def create_user(user_data: dict):
        user_data["created_at"] = datetime.utcnow()
        user_data["updated_at"] = datetime.utcnow()

        result = await users.insert_one(user_data)

        return await users.find_one({"_id": result.inserted_id})

    @staticmethod
    async def update_user(google_id: str, update_data: dict):

        update_data["updated_at"] = datetime.utcnow()

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
    async def update_language(user_id: str, language: str):

        result = await users.update_one(
            {"_id": ObjectId(user_id)},

            {
                "$set": {


                    "preferred_language": language,
                    "updated_at": datetime.utcnow()
                }
            }
        )

        print("Matched:", result.matched_count)
        print("Modified:", result.modified_count)
      

    @staticmethod
    async def delete_user(user_id: str):
        await users.delete_one(
            {"_id": ObjectId(user_id)}
        )