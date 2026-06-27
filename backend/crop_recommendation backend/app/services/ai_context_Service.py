from app.database.mongodb import disease_collection, crop_collection


async def get_user_context(user_id: str):

    latest_disease = disease_collection.find_one(
        {"user_id": user_id},
        sort=[("created_at", -1)]
    )

    latest_crop = crop_collection.find_one(
        {"user_id": user_id},
        sort=[("created_at", -1)]
    )

    if latest_disease:
        latest_disease.pop("_id", None)

    if latest_crop:
        latest_crop.pop("_id", None)

    return {
        "user_id": user_id,
        "last_detection": latest_disease,
        "last_recommendation": latest_crop
    }