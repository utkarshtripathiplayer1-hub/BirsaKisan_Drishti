from datetime import datetime

from app.database.mongodb import active_crop_collection


class ActiveCropRepository:

    async def save(self, crop: dict):

        crop["created_at"] = datetime.utcnow()

        result = await active_crop_collection.insert_one(crop)

        return str(result.inserted_id)

    async def get_active_crop(self, user_id: str):

        return await active_crop_collection.find_one(
            {
                "user_id": user_id,
                "status": "Growing"
            }
        )


active_crop_repository = ActiveCropRepository()