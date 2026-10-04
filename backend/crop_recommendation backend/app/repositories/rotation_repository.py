
from datetime import datetime, timezone
from bson import ObjectId
from bson.errors import InvalidId

from app.database.mongodb import crop_collection, rotation_collection


class RotationRepository:

    async def get_recommendation(
        self,
        recommendation_id: str,
        user_id: str
    ):
        try:
            object_id = ObjectId(recommendation_id)
        except (InvalidId, TypeError):
            return None

        return await crop_collection.find_one({
            "_id": object_id,
            "user_id": user_id
        })

    async def save(
        self,
        rotation: dict,
        user_id: str
    ):
        rotation["user_id"] = user_id
        rotation["created_at"] = datetime.now(timezone.utc)

        result = await rotation_collection.insert_one(rotation)

        return str(result.inserted_id)


rotation_repository = RotationRepository()

