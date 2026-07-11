from datetime import datetime, timedelta

from fastapi import HTTPException

from app.repositories.crop_repository import crop_repository
from app.repositories.active_crop_repository import (
    active_crop_repository
)
from app.services.crop_knowledge_service import (
    crop_knowledge_service
)


class ActiveCropService:

    def start_crop(
        self,
        recommendation_id: str,
        user_id: str
    ):

        # Get crop recommendation
        recommendation = crop_repository.get_by_id(
            recommendation_id
        )

        if not recommendation:
            raise HTTPException(
                status_code=404,
                detail="Recommendation not found."
            )

        # Get crop knowledge
        crop_info = crop_knowledge_service.get_crop_info(
            recommendation["recommended_crop"]
        )

        duration = 120

        if crop_info:
            duration = crop_info.get(
                "duration_days",
                120
            )

        planted_on = datetime.utcnow()

        crop = {

            "user_id": user_id,

            "recommendation_id": recommendation_id,

            "crop_name": recommendation["recommended_crop"],

            "status": "Growing",

            "planted_on": planted_on,

            "expected_harvest": planted_on + timedelta(
                days=duration
            )

        }

        crop_id = active_crop_repository.save(
            crop
        )

        return {

            "message": "Crop started successfully.",

            "active_crop_id": crop_id,

            "crop_name": recommendation["recommended_crop"],

            "expected_harvest": crop["expected_harvest"]

        }

    def get_current_crop(
        self,
        user_id: str
    ):

        crop = active_crop_repository.get_active_crop(
            user_id
        )

        if not crop:
            raise HTTPException(
                status_code=404,
                detail="No active crop found."
            )

        return self.build_current_crop(
            crop
        )

    def build_current_crop(
        self,
        crop
    ):

        if not crop:
            return None

        planted_on = crop["planted_on"]
        harvest = crop["expected_harvest"]

        total_days = max(
            (harvest - planted_on).days,
            1
        )

        completed = max(
            (datetime.utcnow() - planted_on).days,
            0
        )

        remaining = max(
            total_days - completed,
            0
        )

        progress = round(
            min((completed / total_days) * 100, 100),
            2
        )

        return {

            "crop_name": crop["crop_name"],

            "status": crop["status"],

            "planted_on": planted_on,

            "expected_harvest": harvest,

            "days_completed": completed,

            "days_remaining": remaining,

            "progress": progress

        }


active_crop_service = ActiveCropService()