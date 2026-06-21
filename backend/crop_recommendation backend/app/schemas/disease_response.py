from pydantic import BaseModel


class WeatherConditions(BaseModel):

    temperature: str
    humidity: str
    ph: str


class DiseaseResponse(BaseModel):

    crop_type: str

    disease_name: str

    severity: float

    disease_stage: str

    mortality_rate: str

    overview: str

    weather_conditions: WeatherConditions

    precautions: list[str]

    organic_cure: list[str]

    chemical_cure: list[str]