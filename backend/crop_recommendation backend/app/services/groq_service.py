import os
import json
import base64
import time
import logging

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException



# ============================================================
# Logging
# ============================================================

logger = logging.getLogger("crop_backend")


# ============================================================
# Groq Configuration
# ============================================================

GROQ_API_KEY = os.getenv("GROQ_API_KEY")

logger = logging.getLogger("crop_backend")


GROQ_API_KEY = os.getenv("GROQ_API_KEY")

GROQ_MODEL = os.getenv(
    "GROQ_MODEL",
    "qwen/qwen3.6-27b"
)


client = AsyncGroq(
    api_key=GROQ_API_KEY
)


# ============================================================
# System Prompt
# ============================================================

SYSTEM_PROMPT = """
You are Birsa-Kisan Drishti AI, an expert agricultural assistant
(plant pathology, agronomy, entomology, soil science, horticulture).

You analyze an image of a plant or ANY plant part — whole plant,
branch, leaf, stem, fruit, flower, or root — for any crop type.



client = AsyncGroq(
    api_key=GROQ_API_KEY
)



SYSTEM_PROMPT = """
You are Birsa-Kisan Drishti AI, an expert agricultural
plant disease detection assistant.

Analyze the uploaded plant image carefully.

You can analyze:
- leaves
- stems
- fruits
- flowers
- branches
- roots
- whole plants

Base your conclusion ONLY on visible evidence.

Never claim absolute certainty from one image.

If the image is unclear, not a plant, or there is insufficient
visual evidence:

- set health_status to "Unknown"
- set disease_name to "Unknown"
- use a low confidence value
- recommend a clearer image or field inspection

For any field that cannot be determined from the image,
use null.

Never guess chemical dosages, disease biology, or other
information that cannot be established from the image.

Return ONLY valid JSON.
No markdown.
No code blocks.
No text outside JSON.
"""


# ============================================================
# User Prompt
# ============================================================

USER_PROMPT = """
Analyze this plant image and return exactly this JSON:

{
  "crop_type": "",
  "plant_part": "",
  "health_status": "",
  "disease_name": "",
  "confidence": 0.0,
  "severity": "",
  "disease_stage": "",
  "spread_risk": "",

  "visual_analysis": {
    "symptoms_detected": [],
    "affected_parts": [],
    "color_changes": [],
    "estimated_affected_area_percent": 0
},

  "differential_diagnosis": [
    {
      "name": "",
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
If the image is unclear, not a plant, or there is not
enough visual evidence, return:

disease_name = "Unknown"
confidence = a low value
severity = 0
disease_stage = "None"
mortality_rate = "0%"

Do not invent information.

Return ONLY valid JSON.
Do not use markdown.
Do not use code blocks.
Do not add explanations outside JSON.
"""
}

USER_PROMPT = """
Analyze the uploaded plant image.

Return EXACTLY this JSON structure:

{
  "crop_type": "Ficus",
  "disease_name": "Unknown",
  "confidence": 0.95,
  "severity": 0,
  "disease_stage": "None",
  "mortality_rate": "0%",
  "overview": "The leaf appears healthy with no visible signs of disease.",
  "weather_conditions": {
    "temperature": "25-30°C",
    "humidity": "60-70%",
    "ph": "6.0-7.0"
  },
  "precautions": [],
  "organic_cure": [],
  "chemical_cure": []
}

RULES:

1. crop_type:
   Identify the crop/plant if visually possible.
   Otherwise use "Unknown".


severity:
Very Low | Low | Moderate | High | Critical | Unknown

2. disease_name:
   Identify the most likely visible disease.
   If the plant appears healthy, use "Unknown".
   If evidence is insufficient, use "Unknown".


3. confidence:
   Number between 0.0 and 1.0.
spread_risk:
Very Low | Low | Moderate | High | Very High | Unknown

4. severity:
   Number between 0 and 100.
   0 means healthy/no visible disease.
   Higher values indicate greater visible severity.

5. disease_stage:
   Use one of:
   "None"
   "Early"
   "Early-Mid"
   "Mid"
   "Mid-Late"
   "Late"

6. mortality_rate:
   Return a percentage string such as:
   "0%"
   "20%"
   "55%"

7. overview:
   Give a short farmer-friendly explanation.

8. weather_conditions:
   Provide reasonable environmental conditions related
   to the identified disease if known.

   If they cannot be determined, use:
   "Unknown"

9. precautions:
   Provide practical precautions.

10. organic_cure:
    Provide organic treatment suggestions.

11. chemical_cure:
    Provide chemical treatment suggestions.

IMPORTANT:
Do NOT provide chemical dosage unless it can be safely
and reliably determined.

If the plant is healthy:
- disease_name = "Unknown"
- severity = 0
- disease_stage = "None"
- mortality_rate = "0%"
- organic_cure = []
- chemical_cure = []

Return ONLY JSON.
"""

IMPORTANT:

- Never return null for crop_type.
- Never return null for plant_part.
- Never return null for health_status.
- Never return null for disease_name.
- Never return null for severity.
- Never return null for disease_stage.
- Never return null for spread_risk.
- Never return null for visual_analysis.
- Never return null for possible_causes.
- Never return null for lists.
- If chemical treatment cannot be determined, return [].
- If information cannot be determined, use "Unknown" or [].
"""


# ============================================================
# Normalize Model Response
# ============================================================

def normalize_disease_response(data: dict) -> dict:
    """
    Convert Qwen's response into a safe structure.

    This prevents null values from reaching Flutter/FastAPI
    response validation.
    """

    if not isinstance(data, dict):
        data = {}


    # --------------------------------------------------------
    # Basic fields
    # --------------------------------------------------------

    data["crop_type"] = (
        data.get("crop_type")
        or "Unknown"
    )

    data["plant_part"] = (
        data.get("plant_part")
        or "Unknown"
    )

    data["health_status"] = (
        data.get("health_status")
        or "Unknown"
    )

    data["disease_name"] = (
        data.get("disease_name")
        or "Unknown"
    )

    data["severity"] = (
        data.get("severity")
        or "Unknown"
    )

    data["disease_stage"] = (
        data.get("disease_stage")
        or "Unknown"
    )

    data["spread_risk"] = (
        data.get("spread_risk")
        or "Unknown"
    )


    # --------------------------------------------------------
    # Confidence
    # --------------------------------------------------------

    confidence = data.get("confidence")

    if confidence is None:
        confidence = 0.0

    try:
        confidence = float(confidence)
    except (TypeError, ValueError):
        confidence = 0.0

    # Keep confidence inside 0-1
    confidence = max(
        0.0,
        min(1.0, confidence)
    )

    data["confidence"] = confidence


    # --------------------------------------------------------
    # Visual Analysis
    # --------------------------------------------------------

    visual = data.get("visual_analysis")

    if not isinstance(visual, dict):
        visual = {}


    symptoms = visual.get(
        "symptoms_detected"
    )

    if not isinstance(symptoms, list):
        symptoms = []

    visual["symptoms_detected"] = [
        str(item)
        for item in symptoms
        if item is not None
    ]


    affected_parts = visual.get(
        "affected_parts"
    )

    if not isinstance(affected_parts, list):
        affected_parts = []

    visual["affected_parts"] = [
        str(item)
        for item in affected_parts
        if item is not None
    ]


    color_changes = visual.get(
        "color_changes"
    )

    if not isinstance(color_changes, list):
        color_changes = []

    visual["color_changes"] = [
        str(item)
        for item in color_changes
        if item is not None
    ]


    affected_area = visual.get(
        "estimated_affected_area_percent"
    )

    if affected_area is None:
        affected_area = 0.0

    try:
        affected_area = float(
            affected_area
        )
    except (TypeError, ValueError):
        affected_area = 0.0

    # Keep percentage between 0 and 100
    affected_area = max(
        0.0,
        min(100.0, affected_area)
    )

    visual[
        "estimated_affected_area_percent"
    ] = affected_area

    data["visual_analysis"] = visual


    # --------------------------------------------------------
    # Differential Diagnosis
    # --------------------------------------------------------

    differential = data.get(
        "differential_diagnosis"
    )

    if not isinstance(differential, list):
        differential = []


    normalized_differential = []

    for item in differential:

        if not isinstance(item, dict):
            continue

        name = (
            item.get("name")
            or "Unknown"
        )

        reason = (
            item.get("reason")
            or ""
        )

        probability = item.get(
            "probability"
        )

        if probability is None:
            probability = 0.0

        try:
            probability = float(
                probability
            )
        except (TypeError, ValueError):
            probability = 0.0

        probability = max(
            0.0,
            min(1.0, probability)
        )

        normalized_differential.append(
            {
                "name": str(name),
                "probability": probability,
                "reason": str(reason),
            }
        )

    data[
        "differential_diagnosis"
    ] = normalized_differential


    # --------------------------------------------------------
    # Possible Causes
    # --------------------------------------------------------

    causes = data.get(
        "possible_causes"
    )

    if not isinstance(causes, dict):
        causes = {}


    causes["primary"] = (
        causes.get("primary")
        or ""
    )


    secondary = causes.get(
        "secondary"
    )

    if not isinstance(secondary, list):
        secondary = []


    causes["secondary"] = [
        str(item)
        for item in secondary
        if item is not None
    ]


    data["possible_causes"] = causes


    # --------------------------------------------------------
    # Immediate Actions
    # --------------------------------------------------------

    immediate_actions = data.get(
        "immediate_actions"
    )

    if not isinstance(
        immediate_actions,
        list
    ):
        immediate_actions = []


    data["immediate_actions"] = [
        str(item)
        for item in immediate_actions
        if item is not None
    ]


    # --------------------------------------------------------
    # Organic Treatment
    # --------------------------------------------------------

    organic_treatment = data.get(
        "organic_treatment"
    )

    if not isinstance(
        organic_treatment,
        list
    ):
        organic_treatment = []


    data["organic_treatment"] = [
        str(item)
        for item in organic_treatment
        if item is not None
    ]


    # --------------------------------------------------------
    # Chemical Treatment
    # --------------------------------------------------------

    chemical_treatment = data.get(
        "chemical_treatment"
    )

    # Qwen may return:
    #
    # null
    #
    # or a string
    #
    # or a list.
    #
    # Always convert it to a list.

    if chemical_treatment is None:
        chemical_treatment = []

    elif isinstance(
        chemical_treatment,
        str
    ):
        chemical_treatment = [
            chemical_treatment
        ]

    elif not isinstance(
        chemical_treatment,
        list
    ):
        chemical_treatment = []


    data["chemical_treatment"] = [
        str(item)
        for item in chemical_treatment
        if item is not None
    ]


    return data


# ============================================================
# Analyze Plant
# ============================================================

async def analyze_plant(
    image_bytes: bytes,
    content_type: str = "image/jpeg"
):

    image_base64 = base64.b64encode(
        image_bytes
    ).decode("utf-8")

    result = None

    start = time.time()



    try:

        # ----------------------------------------------------
        # Call Groq / Qwen Vision
        # ----------------------------------------------------


    try:


        response = await client.chat.completions.create(

            model=GROQ_MODEL,

            response_format={
                "type": "json_object"
            },

            reasoning_effort="none",

            messages=[
                {
                    "role": "system",
                    "content": SYSTEM_PROMPT
                },
                {
                    "role": "user",
                    "content": [

                        {
                            "type": "text",
                            "text": USER_PROMPT
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

            temperature=0.3,

            max_tokens=1200,

            timeout=60

        )


        # ----------------------------------------------------
        # Get response
        # ----------------------------------------------------

        result = (
            response
            .choices[0]
            .message
            .content
        )


        if not result:

            logger.error(

                "Qwen returned an empty response"

                "Groq returned empty response"
            )

            raise HTTPException(
                status_code=502,
                detail="Disease detection returned an empty response."

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

            data = json.loads(
                result
            )

        except json.JSONDecodeError:

            preview = (
                result[:500]
                if result
                else "no response"
            )

            logger.error(
                "Qwen returned invalid JSON: %s",
                preview
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Could not parse disease result, "
                    "please retry."
                ),
            )


        # ----------------------------------------------------
        # Normalize response
        # ----------------------------------------------------

        data = normalize_disease_response(
            data
        )


        # ----------------------------------------------------
        # Metadata
        # ----------------------------------------------------

        prediction_time = int(
            (time.time() - start) * 1000

        # --------------------------------------------------
        # Normalize missing fields
        # --------------------------------------------------

        data.setdefault(
            "crop_type",
            "Unknown"
        )

        data.setdefault(
            "disease_name",
            "Unknown"
        )

        data.setdefault(
            "confidence",
            0.0
        )

        data.setdefault(
            "severity",
            0
        )

        data.setdefault(
            "disease_stage",
            "None"
        )

        data.setdefault(
            "mortality_rate",
            "0%"
        )

        data.setdefault(
            "overview",
            ""
        )

        data.setdefault(
            "weather_conditions",
            {
                "temperature": "Unknown",
                "humidity": "Unknown",
                "ph": "Unknown"
            }
        )

        data.setdefault(
            "precautions",
            []
        )

        data.setdefault(
            "organic_cure",
            []
        )

        data.setdefault(
            "chemical_cure",
            []
        )
        ) 

        # --------------------------------------------------
        # Normalize weather conditions
        # --------------------------------------------------

        weather = data.get(
            "weather_conditions"
        )

        if not isinstance(weather, dict):

            weather = {}

        weather.setdefault(
            "temperature",
            "Unknown"
        )

        weather.setdefault(
            "humidity",
            "Unknown"
        )

        weather.setdefault(
            "ph",
            "Unknown"
        )

        data["weather_conditions"] = weather

        # --------------------------------------------------
        # Ensure correct types
        # --------------------------------------------------

        if not isinstance(
            data["precautions"],
            list
        ):
            data["precautions"] = []

        if not isinstance(
            data["organic_cure"],
            list
        ):
            data["organic_cure"] = []

        if not isinstance(
            data["chemical_cure"],
            list
        ):
            data["chemical_cure"] = []

        # --------------------------------------------------
        # Add prediction metadata internally
        # --------------------------------------------------

        logger.info(
            "Disease prediction completed in %sms",
            int(
                (time.time() - start) * 1000
            )

        )


        data.setdefault(
            "metadata",
            {}
        )


        if not isinstance(
            data["metadata"],
            dict
        ):
            data["metadata"] = {}


        data["metadata"][
            "prediction_time_ms"
        ] = prediction_time


        # ----------------------------------------------------
        # Log successful prediction
        # ----------------------------------------------------

        logger.info(
            "Disease prediction completed "
            "in %sms | crop=%s | disease=%s",
            prediction_time,
            data.get("crop_type"),
            data.get("disease_name"),
        )


        return data


    # ========================================================
    # Groq Rate Limit
    # ========================================================

    except RateLimitError:

        logger.warning(
    
            "Groq rate limit reached")

        raise HTTPException(
            status_code=503,
            detail="Disease detection busy, please retry shortly."

        )

        raise HTTPException(
            status_code=503,
            detail=(
                "Disease detection busy, "
                "please retry shortly."
            ),
        )


    # ========================================================
    # Groq API Error
    # ========================================================

    except APIError as e:


        logger.error(
            "Groq vision error: %s",
            e


        logger.error(
            "Groq vision error: %s",
            e
        )

        raise HTTPException(
            status_code=502,
            detail="Disease detection temporarily unavailable."
        )

    except json.JSONDecodeError:

        preview = (
            result[:300]
            if result
            else "no response"
        )

        logger.error(
            "Invalid JSON returned by Groq: %s",
            preview

        )

        raise HTTPException(
            status_code=502,

            detail=(
                "Disease detection temporarily "
                "unavailable."
            ),

            detail="Could not parse disease result."

        )


    # ========================================================
    # FastAPI HTTP Exception
    # ========================================================

    except HTTPException:

        raise


    # ========================================================
    # Unexpected Error
    # ========================================================

    except Exception as e:

        logger.exception(
            "Unexpected disease detection error: %s",
            e
        )

        raise HTTPException(
            status_code=500,

            detail=(
                "Unexpected disease detection error."
            ),
        )

            detail="Unexpected disease detection error."
        )

