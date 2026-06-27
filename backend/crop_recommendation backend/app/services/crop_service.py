from pathlib import Path
import joblib
import pandas as pd

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

    def predict(
        self,
        data,
        user_id
    ):

        # Encode soil type
        soil_encoded = self.soil_encoder.transform(
            [data.Soil_Type]
        )[0]

        # Feature order must match training data
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

        # Predict crop
        prediction = self.model.predict(features)

        crop = self.crop_encoder.inverse_transform(
            prediction
        )[0]

        # Confidence score
        probabilities = self.model.predict_proba(features)

        confidence = round(
            max(probabilities[0]) * 100,
            2
        )

        # Crop information from knowledge file
        crop_info = crop_knowledge_service.get_crop_info(crop)

        result = {
            "user_id": user_id,
            "recommended_crop": crop,
            "confidence": confidence,
            "crop_details": crop_info
        }

        # Save to MongoDB
        recommendation_id = crop_repository.save(
            result.copy()
        )

        result["recommendation_id"] = recommendation_id

        return result


crop_service = CropRecommendationService()