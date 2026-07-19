from pathlib import Path
import joblib
import pandas as pd
from fastapi import HTTPException
from app.repositories.crop_repository import crop_repository
from app.services.crop_knowledge_service import crop_knowledge_service

BASE_DIR = Path(__file__).resolve().parent.parent

MODEL_PATH = BASE_DIR / "ml_models" / "crop_model.pkl"
CROP_ENCODER_PATH = BASE_DIR / "ml_models" / "crop_encoder.pkl"
SOIL_ENCODER_PATH = BASE_DIR / "ml_models" / "soil_encoder.pkl"


class CropRecommendationService:

    def __init__(self):
        self.model = joblib.load(MODEL_PATH)
        self.crop_encoder = joblib.load(CROP_ENCODER_PATH)
        self.soil_encoder = joblib.load(SOIL_ENCODER_PATH)

    async def predict(
        self,
        data,
        user_id
    ):

        soil_type = data.Soil_Type.strip().title()

        try:
            soil_encoded = self.soil_encoder.transform([soil_type])[0]
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail={
                    "message": "Invalid soil type.",
                    "allowed_values": list(self.soil_encoder.classes_)
                }
            )

        features = pd.DataFrame([{
            "N": data.N,
            "P": data.P,
            "K": data.K,
            "pH": data.pH,
            "Temperature": data.Temperature,
            "Humidity": data.Humidity,
            "Rainfall": data.Rainfall,
            "Soil_Moisture": data.Soil_Moisture,
            "Soil_Type": soil_encoded
        }])

        prediction = self.model.predict(features)

        crop = self.crop_encoder.inverse_transform(
            prediction
        )[0]

        probabilities = self.model.predict_proba(features)

        confidence = round(
            max(probabilities[0]) * 100,
            2
        )

        crop_info = crop_knowledge_service.get_crop_info(crop)

        result = {
            "user_id": user_id,
            "recommended_crop": crop,
            "confidence": confidence,
            "crop_details": crop_info,
            "soil_data": {
                "N": data.N,
                "P": data.P,
                "K": data.K,
                "pH": data.pH,
                "Temperature": data.Temperature,
                "Humidity": data.Humidity,
                "Rainfall": data.Rainfall,
                "Soil_Moisture": data.Soil_Moisture,
                "Soil_Type": data.Soil_Type
            }
        }

        recommendation_id = await crop_repository.save(
            result.copy()
        )

        result["recommendation_id"] = recommendation_id

        return result


crop_service = CropRecommendationService()