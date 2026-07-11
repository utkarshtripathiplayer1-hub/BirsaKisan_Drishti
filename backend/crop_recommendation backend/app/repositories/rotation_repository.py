from datetime import datetime
from bson import ObjectId

from app.database.mongodb import (
    crop_collection,
    rotation_collection
)


class RotationRepository:

    def get_recommendation(self, recommendation_id: str):

        return crop_collection.find_one(
            {
                "_id": ObjectId(recommendation_id)
            }
        )

    def save(self, rotation: dict):

        rotation["created_at"] = datetime.utcnow()

        result = rotation_collection.insert_one(
            rotation
        )

        return str(result.inserted_id)


rotation_repository = RotationRepository()