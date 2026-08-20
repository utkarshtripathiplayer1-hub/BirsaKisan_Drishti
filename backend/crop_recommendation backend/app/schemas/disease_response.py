from pydantic import BaseModel, Field
from typing import Optional


class VisualAnalysis(BaseModel):
    symptoms_detected: list[str] = []
    affected_parts: list[str] = []
    color_changes: list[str] = []
    estimated_affected_area_percent: float = 0


class DifferentialDiagnosis(BaseModel):
    name: str
    probability: float = Field(ge=0.0, le=1.0)
    reason: str


class PossibleCauses(BaseModel):
    primary: Optional[str] = None
    secondary: list[str] = []


class DiseaseResponse(BaseModel):
    crop_type: str
    plant_part: str
    health_status: str
    disease_name: str

    confidence: float = Field(ge=0.0, le=1.0)

    severity: str
    disease_stage: str
    spread_risk: str

    visual_analysis: VisualAnalysis

    differential_diagnosis: list[DifferentialDiagnosis] = []

    possible_causes: PossibleCauses

    immediate_actions: list[str] = []

    organic_treatment: list[str] = []

    chemical_treatment: Optional[list[str]] = None

    metadata: Optional[dict] = None