from datetime import datetime
from bson import ObjectId

from app.database.mongodb import (
    crop_collection,
    rotation_collection
)


class RotationRepository:

    async def get_recommendation(self, recommendation_id: str):

        return await crop_collection.find_one(
            {
                "_id": ObjectId(recommendation_id)
            }
        )

    async def save(self, rotation: dict):

        rotation["created_at"] = datetime.utcnow()

        result = await rotation_collection.insert_one(rotation)

        return str(result.inserted_id)


rotation_repository = RotationRepository()