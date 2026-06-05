from pydantic import BaseModel
from typing import Dict, Any


class CropRecommendationRequest(BaseModel):
    N: float
    P: float
    K: float
    pH: float
    soil_moisture: float
    temperature: float
    humidity: float
    rainfall: float
    solar_radiation: float
    elevation: float
    irrigation: str 
    previous_crop: str


class CropRecommendationResponse(BaseModel):
    recommended_crop: str
    confidence: float
    recommended_conditions: Dict[str, Any]