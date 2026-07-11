from datetime import datetime
from bson import ObjectId

from app.database.mongodb import crop_collection


class CropRepository:

    def save(self, recommendation: dict):

        recommendation["created_at"] = datetime.utcnow()

        result = crop_collection.insert_one(
            recommendation
        )

        return str(result.inserted_id)

    def get_by_id(self, recommendation_id: str):

        return crop_collection.find_one(
            {"_id": ObjectId(recommendation_id)}
        )

    # NEW
    def get_latest_by_user(self, user_id: str):

        return crop_collection.find_one(
            {"user_id": user_id},
            sort=[("created_at", -1)]
        )
    def get_latest_by_user(
        self,
        user_id: str
    ):

        return crop_collection.find_one(
            {"user_id": user_id},
            sort=[("created_at", -1)]
        )


crop_repository = CropRepository()


    