from pydantic import BaseModel


class WeatherSchema(BaseModel):
    temperature: float
    humidity: float
    rainfall: float


class SoilSchema(BaseModel):
    health: str
    type: str
    moisture: float
    ph: float
    N: int
    P: int
    K: int


class MyFarmResponse(BaseModel):

    recommended_crop: str

    confidence: float

    crop_details: dict

    soil: SoilSchema

    weather: WeatherSchema