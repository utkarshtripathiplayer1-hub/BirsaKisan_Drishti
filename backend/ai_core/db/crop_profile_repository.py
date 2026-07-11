from db.collections import crop_profile
from bson import ObjectId


async def create_crop_profile(profile_data: dict):
    result = await crop_profile.insert_one(profile_data)
    return str(result.inserted_id)


async def get_crop_profile(user_id: str):
    return await crop_profile.find_one({"user_id": user_id})


async def profile_exists(user_id: str) -> bool:
    profile = await crop_profile.find_one(
        {"user_id": user_id},
        {"_id": 1}
    )
    return profile is not None


async def update_crop_profile(user_id: str, update_data: dict):
    await crop_profile.update_one(
        {"user_id": user_id},
        {"$set": update_data}
    )


async def delete_crop_profile(user_id: str):
    await crop_profile.delete_one(
        {"user_id": user_id}
    )