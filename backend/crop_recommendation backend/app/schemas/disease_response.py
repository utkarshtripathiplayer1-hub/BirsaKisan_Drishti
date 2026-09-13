from pydantic import BaseModel, Field


class VisualAnalysis(BaseModel):
    symptoms_detected: list[str] = Field(default_factory=list)
    affected_parts: list[str] = Field(default_factory=list)
    color_changes: list[str] = Field(default_factory=list)
    estimated_affected_area_percent: float = Field(
        default=0.0,
        ge=0.0,
        le=100.0
    )


class DifferentialDiagnosis(BaseModel):
    name: str = "Unknown"
    probability: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0
    )
    reason: str = ""


class PossibleCauses(BaseModel):
    primary: str = ""
    secondary: list[str] = Field(
        default_factory=list
    )


class DiseaseResponse(BaseModel):

    # ========================================================
    # Basic Detection
    # ========================================================

    crop_type: str = "Unknown"

    plant_part: str = "Unknown"

    health_status: str = "Unknown"

    disease_name: str = "Unknown"

    confidence: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0
    )

    severity: str = "Unknown"

    disease_stage: str = "Unknown"

    spread_risk: str = "Unknown"


    # ========================================================
    # Farmer-Friendly Explanation
    # ========================================================

    overview: str = ""

    symptoms: list[str] = Field(
        default_factory=list
    )

    prevention: list[str] = Field(
        default_factory=list
    )

    monitoring: str = ""


    # ========================================================
    # Detailed Visual Analysis
    # ========================================================

    visual_analysis: VisualAnalysis = Field(
        default_factory=VisualAnalysis
    )


    # ========================================================
    # Differential Diagnosis
    # ========================================================

    differential_diagnosis: list[DifferentialDiagnosis] = Field(
        default_factory=list
    )


    # ========================================================
    # Possible Causes
    # ========================================================

    possible_causes: PossibleCauses = Field(
        default_factory=PossibleCauses
    )


    # ========================================================
    # Recommended Actions
    # ========================================================

    immediate_actions: list[str] = Field(
        default_factory=list
    )

    organic_treatment: list[str] = Field(
        default_factory=list
    )

    chemical_treatment: list[str] = Field(
        default_factory=list
    )


    # ========================================================
    # Metadata
    # ========================================================

    metadata: dict = Field(
        default_factory=dict
    )
