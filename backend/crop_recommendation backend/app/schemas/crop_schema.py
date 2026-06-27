from pydantic import BaseModel


class CropRecommendationRequest(BaseModel):
    N: float
    P: float
    K: float
    pH: float
    Temperature: float
    Humidity: float
    Rainfall: float
    Soil_Moisture: float
    Soil_Type: str