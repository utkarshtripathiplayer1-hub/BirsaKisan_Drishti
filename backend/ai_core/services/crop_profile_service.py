from datetime import datetime

from db.crop_profile_repository import (
    create_crop_profile,
    get_crop_profile,
    update_crop_profile,
    delete_crop_profile,
    profile_exists,
)
from db.user_repository import UserRepository

async def create_profile(user_id: str, profile_data: dict):

    if await profile_exists(user_id):
        raise ValueError("Crop profile already exists.")

    profile_data["user_id"] = user_id
   
    profile_data["created_at"] = datetime.utcnow()
    profile_data["updated_at"] = datetime.utcnow()

    await create_crop_profile(profile_data)

    return {"message": "Crop profile created successfully."}

#GETPROFILE

async def get_profile(user_id: str):

    # Check if profile exists
    profile = await get_crop_profile(user_id)

    # If not, create an empty profile
    if not profile:

        profile = {
            "user_id": user_id,

            "basic_info": {
                "role": "Farmer",
                "age": 0,
                "gender": "Other",
                "education": "No Formal Education",
                "phone": ""
            },

            "location": {
                "country": "",
                "state": "",
                "district": "",
                "village": "",
                "latitude": 0.0,
                "longitude": 0.0
            },

            "farm_info": {
                "farm_name": "",
                "farm_size": 0,
                "soil_type": "",
                "irrigation_method": ""
            },

            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow()
        }

        await create_crop_profile(profile)

        # Fetch the newly created profile
        profile = await get_crop_profile(user_id)

    # Get user details
    user = await UserRepository.get_by_id(user_id)
    print(user)

    profile["_id"] = str(profile["_id"])

    return {
        "user": {
            "name": user["name"],
            "email": user["email"],
            "picture": user.get("picture")
        },
        "basic_info": profile["basic_info"],
        "location": profile["location"],
        "farm_info": profile["farm_info"],
        "created_at": profile["created_at"],
        "updated_at": profile["updated_at"]
    }
    


#UPDATEPROFILE
async def update_profile(user_id: str, update_data: dict):

    if not await profile_exists(user_id):
        raise ValueError("Crop profile not found.")

    update_data["updated_at"] = datetime.utcnow()

    await update_crop_profile(user_id, update_data)

    return {"message": "Crop profile updated successfully."}

#DELETE PROFILE(OPTIONAL)

async def delete_profile(user_id: str):

    if not await profile_exists(user_id):
        raise ValueError("Crop profile not found.")

    await delete_crop_profile(user_id)

    return {"message": "Crop profile deleted successfully."}