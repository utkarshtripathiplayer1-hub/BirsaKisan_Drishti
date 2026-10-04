
from datetime import datetime, timezone
from bson import ObjectId
from bson.errors import InvalidId

from app.database.mongodb import crop_collection


class CropRepository:

    async def save(self, recommendation: dict):
        recommendation["created_at"] = datetime.now(timezone.utc)

        result = await crop_collection.insert_one(recommendation)

        return str(result.inserted_id)

    async def get_by_id(
        self,
        recommendation_id: str,
        user_id: str
    ):
        try:
            object_id = ObjectId(recommendation_id)
        except (InvalidId, TypeError):
            return None

        return await crop_collection.find_one(
            {
                "_id": object_id,
                "user_id": user_id
            }
        )

    async def get_latest_by_user(
        self,
        user_id: str
    ):
        return await crop_collection.find_one(
            {
                "user_id": user_id
            },
            sort=[
                ("created_at", -1)
            ]
        )


crop_repository = CropRepository()
