import json
from pathlib import Path

from fastapi import HTTPException

from app.repositories.rotation_repository import (
    rotation_repository
)

BASE_DIR = Path(__file__).resolve().parent.parent
ROTATION_FILE = BASE_DIR / "data" / "crop_data.json"


class RotationService:

    def __init__(self):

        with open(
            ROTATION_FILE,
            "r",
            encoding="utf-8"
        ) as f:

            self.rotation_data = json.load(f)

    async def get_rotation(
        self,
        recommendation_id: str
    ):

        recommendation = await rotation_repository.get_recommendation(
            recommendation_id
        )

        if recommendation is None:
            raise HTTPException(
                status_code=404,
                detail="Recommendation not found."
            )

        crop = recommendation["recommended_crop"]

        if crop not in self.rotation_data:
            raise HTTPException(
                status_code=404,
                detail=f"No rotation data available for {crop}"
            )

        data = self.rotation_data[crop]

        result = {

            "recommendation_id": recommendation_id,

            "current_crop": crop,

            "next_crop": data["next_crop"],

            "reason": data["reason"],

            "benefits": data["benefits"],

            "avoid": data["avoid"]

        }

        rotation_id = await rotation_repository.save(
            result.copy()
        )

        result["rotation_id"] = rotation_id

        return result

    def get_rotation_summary(
        self,
        crop_name: str
    ):

        if crop_name not in self.rotation_data:
            return None

        data = self.rotation_data[crop_name]

        return {

            "current_crop": crop_name,

            "next_crop": data["next_crop"],

            "reason": data["reason"]

        }


rotation_service = RotationService()