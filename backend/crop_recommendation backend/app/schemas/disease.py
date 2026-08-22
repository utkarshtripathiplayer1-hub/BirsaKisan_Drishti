from pydantic import BaseModel, Field


class WeatherConditions(BaseModel):
    temperature: str = ""
    humidity: str = ""
    ph: str = ""


class DiseaseResponse(BaseModel):
    crop_type: str = "Unknown"

    disease_name: str = "Unknown"

    confidence: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0
    )

    severity: float = Field(
        default=0.0,
        ge=0.0,
        le=100.0
    )

    disease_stage: str = "None"

    mortality_rate: str = "0%"

    overview: str = ""

    weather_conditions: WeatherConditions = Field(
        default_factory=WeatherConditions
    )

    precautions: list[str] = Field(
        default_factory=list
    )

    organic_cure: list[str] = Field(
        default_factory=list
    )

    chemical_cure: list[str] = Field(
        default_factory=list
    )