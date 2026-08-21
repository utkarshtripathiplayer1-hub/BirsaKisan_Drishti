from pydantic import BaseModel, Field


class VisualAnalysis(BaseModel):
    symptoms_detected: list[str] = Field(default_factory=list)
    affected_parts: list[str] = Field(default_factory=list)
    color_changes: list[str] = Field(default_factory=list)
    estimated_affected_area_percent: float = 0.0


class DifferentialDiagnosis(BaseModel):
    name: str = "Unknown"
    probability: float = Field(default=0.0, ge=0.0, le=1.0)
    reason: str = ""


class PossibleCauses(BaseModel):
    primary: str = ""
    secondary: list[str] = Field(default_factory=list)


class DiseaseResponse(BaseModel):
    crop_type: str = "Unknown"
    plant_part: str = "Unknown"
    health_status: str = "Unknown"
    disease_name: str = "Unknown"

    confidence: float = Field(default=0.0, ge=0.0, le=1.0)

    severity: str = "Unknown"
    disease_stage: str = "Unknown"
    spread_risk: str = "Unknown"

    visual_analysis: VisualAnalysis = Field(
        default_factory=VisualAnalysis
    )

    differential_diagnosis: list[DifferentialDiagnosis] = Field(
        default_factory=list
    )

    possible_causes: PossibleCauses = Field(
        default_factory=PossibleCauses
    )

    immediate_actions: list[str] = Field(
        default_factory=list
    )

    organic_treatment: list[str] = Field(
        default_factory=list
    )

    chemical_treatment: list[str] = Field(
        default_factory=list
    )

    metadata: dict = Field(
        default_factory=dict
    )
