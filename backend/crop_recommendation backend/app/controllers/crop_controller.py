from app.services.crop_service import (
    CropRecommendationService
)


class CropController:

    @staticmethod
    async def recommend_crop(data):

        result = CropRecommendationService.predict(
            data
        )

        return result