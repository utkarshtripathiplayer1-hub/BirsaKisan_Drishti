import os
import json
import base64
import time
import logging

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException


logger = logging.getLogger("crop_backend")


# ============================================================
# GROQ CONFIGURATION
# ============================================================

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL = os.getenv("GROQ_MODEL", "qwen/qwen3.6-27b")

client = AsyncGroq(api_key=GROQ_API_KEY)


# ============================================================
# SYSTEM PROMPT
# ============================================================

SYSTEM_PROMPT = """You are Birsa-Kisan Drishti AI, an expert agricultural assistant
specializing in plant pathology, agronomy, entomology, soil science, and horticulture.

You analyze an image of a plant or ANY plant part — whole plant, branch, leaf, stem,
fruit, flower, or root — for any crop type.

Base every conclusion ONLY on visible symptoms.

Never claim absolute certainty from one image.
Set confidence honestly between 0.0 and 1.0.

If the image is unclear, not a plant, or there is insufficient visual evidence:

- set health_status to "Unknown"
- set disease_name to "Unknown"
- use a low confidence value
- recommend a clearer image or field inspection

IMPORTANT OUTPUT RULES:

- Return ONLY valid JSON.
- Never return markdown.
- Never return code blocks.
- Never return text outside JSON.
- For list fields, ALWAYS return [] when there is no information.
- NEVER return null for list fields.
- For unknown text values, use "Unknown".
- For optional text values where an empty value is appropriate, use "".
- Never invent chemical dosages.
- Never invent disease biology or facts that cannot be supported by the image.
"""


# ============================================================
# USER PROMPT
# ============================================================

USER_PROMPT = """Analyze this plant image and return exactly this JSON structure:

{
  "crop_type": "Unknown",
  "plant_part": "Unknown",
  "health_status": "Unknown",
  "disease_name": "Unknown",
  "confidence": 0.0,
  "severity": "Unknown",
  "disease_stage": "Unknown",
  "spread_risk": "Unknown",

  "visual_analysis": {
    "symptoms_detected": [],
    "affected_parts": [],
    "color_changes": [],
    "estimated_affected_area_percent": 0
  },

  "differential_diagnosis": [
    {
      "name": "Unknown",
      "probability": 0.0,
      "reason": ""
    }
  ],

  "possible_causes": {
    "primary": "",
    "secondary": []
  },

  "immediate_actions": [],
  "organic_treatment": [],
  "chemical_treatment": []
}

ENUMS:

health_status:
Healthy | Diseased | Pest Infested | Nutrient Deficient | Abiotic Stress | Unknown

severity:
Very Low | Low | Moderate | High | Critical | Unknown

disease_stage:
Early | Early-Mid | Mid | Mid-Late | Late | Unknown

spread_risk:
Very Low | Low | Moderate | High | Very High | Unknown

IMPORTANT:

If chemical treatment cannot safely be determined from the image,
return:

"chemical_treatment": []

Do NOT return null.

If there is not enough information for a field, use:
- "Unknown" for strings
- [] for lists
- 0.0 for numeric values where appropriate.
"""


# ============================================================
# RESPONSE NORMALIZATION
# ============================================================

def normalize_disease_response(data: dict) -> dict:
    """
    Normalize Qwen's JSON response so that it always matches
    the FastAPI DiseaseResponse schema.

    This protects the API from null/missing values generated
    by the model.
    """

    # --------------------------------------------------------
    # Top-level string fields
    # --------------------------------------------------------

    string_defaults = {
        "crop_type": "Unknown",
        "plant_part": "Unknown",
        "health_status": "Unknown",
        "disease_name": "Unknown",
        "severity": "Unknown",
        "disease_stage": "Unknown",
        "spread_risk": "Unknown",
    }

    for field, default in string_defaults.items():

        if data.get(field) is None:
            data[field] = default

        elif not isinstance(data.get(field), str):
            data[field] = str(data[field])


    # --------------------------------------------------------
    # Confidence
    # --------------------------------------------------------

    if data.get("confidence") is None:
        data["confidence"] = 0.0

    try:
        data["confidence"] = float(data["confidence"])
    except (TypeError, ValueError):
        data["confidence"] = 0.0

    # Keep confidence inside valid range
    data["confidence"] = max(
        0.0,
        min(1.0, data["confidence"])
    )


    # --------------------------------------------------------
    # Visual analysis
    # --------------------------------------------------------

    visual_analysis = data.get("visual_analysis")

    if not isinstance(visual_analysis, dict):
        visual_analysis = {}

    list_fields = [
        "symptoms_detected",
        "affected_parts",
        "color_changes",
    ]

    for field in list_fields:

        if visual_analysis.get(field) is None:
            visual_analysis[field] = []

        elif not isinstance(visual_analysis[field], list):
            visual_analysis[field] = [str(visual_analysis[field])]


    if visual_analysis.get("estimated_affected_area_percent") is None:
        visual_analysis["estimated_affected_area_percent"] = 0.0

    try:
        visual_analysis["estimated_affected_area_percent"] = float(
            visual_analysis["estimated_affected_area_percent"]
        )
    except (TypeError, ValueError):
        visual_analysis["estimated_affected_area_percent"] = 0.0


    data["visual_analysis"] = visual_analysis


    # --------------------------------------------------------
    # Differential diagnosis
    # --------------------------------------------------------

    differential = data.get("differential_diagnosis")

    if differential is None or not isinstance(differential, list):
        differential = []

    normalized_differential = []

    for item in differential:

        if not isinstance(item, dict):
            continue

        item["name"] = item.get("name") or "Unknown"
        item["reason"] = item.get("reason") or ""

        probability = item.get("probability")

        if probability is None:
            probability = 0.0

        try:
            probability = float(probability)
        except (TypeError, ValueError):
            probability = 0.0

        item["probability"] = max(
            0.0,
            min(1.0, probability)
        )

        normalized_differential.append(item)

    data["differential_diagnosis"] = normalized_differential


    # --------------------------------------------------------
    # Possible causes
    # --------------------------------------------------------

    possible_causes = data.get("possible_causes")

    if not isinstance(possible_causes, dict):
        possible_causes = {}

    if possible_causes.get("primary") is None:
        possible_causes["primary"] = ""

    if possible_causes.get("secondary") is None:
        possible_causes["secondary"] = []

    elif not isinstance(possible_causes["secondary"], list):
        possible_causes["secondary"] = [
            str(possible_causes["secondary"])
        ]

    data["possible_causes"] = possible_causes


    # --------------------------------------------------------
    # List fields
    # --------------------------------------------------------

    list_response_fields = [
        "immediate_actions",
        "organic_treatment",
        "chemical_treatment",
    ]

    for field in list_response_fields:

        value = data.get(field)

        if value is None:
            data[field] = []

        elif not isinstance(value, list):
            data[field] = [str(value)]


    # --------------------------------------------------------
    # Metadata
    # --------------------------------------------------------

    if data.get("metadata") is None:
        data["metadata"] = {}

    elif not isinstance(data.get("metadata"), dict):
        data["metadata"] = {}


    return data


# ============================================================
# ANALYZE PLANT
# ============================================================

async def analyze_plant(
    image_bytes: bytes,
    content_type: str = "image/jpeg",
):
    """
    Analyze a plant image using Qwen multimodal through Groq.
    """

    image_base64 = base64.b64encode(image_bytes).decode("utf-8")

    result = None
    start = time.time()

    try:

        # ----------------------------------------------------
        # Call Qwen through Groq
        # ----------------------------------------------------

        response = await client.chat.completions.create(

            model=GROQ_MODEL,

            response_format={
                "type": "json_object"
            },

            reasoning_effort="none",

            messages=[
                {
                    "role": "system",
                    "content": SYSTEM_PROMPT,
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": USER_PROMPT,
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": (
                                    f"data:{content_type};base64,"
                                    f"{image_base64}"
                                )
                            },
                        },
                    ],
                },
            ],

            temperature=0.7,

            max_tokens=1200,

            timeout=60,
        )


        # ----------------------------------------------------
        # Get model response
        # ----------------------------------------------------

        result = response.choices[0].message.content

        if not result:

            logger.error(
                "Qwen returned an empty response"
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Disease detection returned "
                    "an empty response."
                ),
            )


        # ----------------------------------------------------
        # Parse JSON
        # ----------------------------------------------------

        try:

            data = json.loads(result)

        except json.JSONDecodeError:

            preview = result[:500]

            logger.error(
                f"Qwen returned invalid JSON: {preview}"
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Could not parse disease result, "
                    "please retry."
                ),
            )


        # ----------------------------------------------------
        # Validate basic response type
        # ----------------------------------------------------

        if not isinstance(data, dict):

            logger.error(
                "Qwen response was not a JSON object"
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Disease detection returned "
                    "an invalid response."
                ),
            )


        # ----------------------------------------------------
        # Normalize Qwen response
        # ----------------------------------------------------

        data = normalize_disease_response(data)


        # ----------------------------------------------------
        # Add metadata
        # ----------------------------------------------------

        data.setdefault("metadata", {})

        data["metadata"]["prediction_time_ms"] = int(
            (time.time() - start) * 1000
        )


        logger.info(
            "Disease analysis completed successfully "
            f"in {data['metadata']['prediction_time_ms']} ms"
        )


        return data


    # ========================================================
    # ERROR HANDLING
    # ========================================================

    except RateLimitError:

        logger.warning(
            "Groq rate limit reached during disease detection"
        )

        raise HTTPException(
            status_code=503,
            detail=(
                "Disease detection busy, "
                "please retry shortly."
            ),
        )


    except APIError as e:

        logger.error(
            f"Groq vision API error: {e}"
        )

        raise HTTPException(
            status_code=502,
            detail=(
                "Disease detection temporarily "
                "unavailable."
            ),
        )


    except HTTPException:
        raise


    except Exception as e:

        logger.exception(
            f"Unexpected disease detection error: {e}"
        )

        raise HTTPException(
            status_code=500,
            detail=(
                "Unexpected disease detection error."
            ),
        )
