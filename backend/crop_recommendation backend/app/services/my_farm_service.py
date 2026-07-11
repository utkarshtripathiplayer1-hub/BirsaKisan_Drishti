from fastapi import HTTPException

from app.repositories.my_farm_repository import (
    my_farm_repository
)

from app.services.weather_service import (
    weather_service
)

from app.services.ai_core_service import (
    ai_core_service
)

from app.services.active_crop_service import (
    active_crop_service
)
from app.services.rotation_service import (
    rotation_service
)

class MyFarmService:

    def calculate_soil_health(
        self,
        soil
    ):

        score = 0

        if 80 <= soil["N"] <= 120:
            score += 25

        if 40 <= soil["P"] <= 60:
            score += 25

        if 40 <= soil["K"] <= 60:
            score += 25

        if 6 <= soil["pH"] <= 7.5:
            score += 25

        if score == 100:
            health = "Good"

        elif score >= 50:
            health = "Moderate"

        else:
            health = "Poor"

        return {

            "health": health,

            "score": score

        }

    async def get_dashboard(
        self,
        user_id: str,
        token: str
    ):

        # Latest Crop Recommendation
        recommendation = my_farm_repository.get_latest_crop(
            user_id
        )

        if not recommendation:
            raise HTTPException(
                status_code=404,
                detail="No crop recommendation found."
            )

        # Current Active Crop
        raw_active_crop = my_farm_repository.get_active_crop(
            user_id
        )

        current_crop = active_crop_service.build_current_crop(
            raw_active_crop
        )

        # User Location (AI Core)
        location = ai_core_service.get_location(
            token
        )
        

        print("LOCATION FROM AI CORE:", location)

        # Live Weather
        weather = None

        if (
            location
            and location.get("latitude")
            and location.get("longitude")
        ):

            weather = await weather_service.current_weather(
                location["latitude"],
                location["longitude"]
            )
            print(weather)

        # Soil Information
        soil = recommendation["soil_data"]

        soil_health = self.calculate_soil_health(
            soil
        )

        # Rotation Summary
        rotation = rotation_service.get_rotation_summary(
            recommendation["recommended_crop"]
        )

        # Final Dashboard Response
        return {

            "current_crop": current_crop,

            "recommended_crop": recommendation["recommended_crop"],

            "confidence": recommendation["confidence"],

            "crop_details": recommendation["crop_details"],

            "soil": {

                "health": soil_health["health"],

                "score": soil_health["score"],

                "type": soil["Soil_Type"],

                "moisture": soil["Soil_Moisture"],

                "ph": soil["pH"],

                "N": soil["N"],

                "P": soil["P"],

                "K": soil["K"]

            },

            "weather": weather,

            "location": location,

            "rotation": rotation

        }


my_farm_service = MyFarmService()