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

GROQ_MODEL = os.getenv(
    "GROQ_MODEL",
    "qwen/qwen3.8-27b"
)

client = AsyncGroq(
    api_key=GROQ_API_KEY
)


# ============================================================
# System Prompt
# ============================================================

SYSTEM_PROMPT = """
You are Birsa-Kisan Drishti AI, an expert agricultural
plant health assistant specializing in:

- Plant pathology
- Crop diseases
- Agricultural pests
- Nutrient deficiencies
- Agronomy
- Horticulture

You analyze plant images and provide practical,
farmer-friendly guidance.

Your task is to visually analyze the uploaded image and
identify whether the plant appears:

- Healthy
- Diseased
- Pest Infested
- Nutrient Deficient
- At Risk
- Unknown

IMPORTANT RULES:

1. Base your analysis ONLY on evidence visible in the image.

2. Never claim absolute certainty from a single image.

3. If the image is unclear, not a plant, or there is not
   enough visual evidence:
   - use "Unknown"
   - use 0.0 confidence
   - use empty lists where appropriate
   - do not invent a diagnosis.

4. Do NOT invent temperature, humidity, soil pH, rainfall,
   or other environmental measurements from an image.

5. Do NOT invent chemical dosages.

6. Chemical recommendations must be general and cautious.
   If you cannot confidently recommend one, return [].

7. Confidence must always be between 0.0 and 1.0.

8. Severity must be one of:
   - Very Low
   - Low
   - Moderate
   - High
   - Critical
   - Unknown

9. Disease stage must be one of:
   - None
   - Early
   - Early-Mid
   - Mid
   - Mid-Late
   - Late
   - Unknown

10. Spread risk must be one of:
    - Very Low
    - Low
    - Moderate
    - High
    - Very High
    - Unknown

11. Return ONLY valid JSON.

12. Do NOT return markdown.

13. Do NOT return code blocks.

14. Do NOT add explanations outside the JSON.

15. All farmer-facing explanatory content must use the
    requested language.
"""


# ============================================================
# User Prompt
# ============================================================

USER_PROMPT_TEMPLATE = """
Analyze the uploaded plant image.

The farmer's preferred language is: {language}

Return EXACTLY this JSON structure:

{{
  "crop_type": "Unknown",
  "plant_part": "Unknown",
  "health_status": "Unknown",
  "disease_name": "Unknown",

  "confidence": 0.0,
  "severity": "Unknown",
  "disease_stage": "Unknown",
  "spread_risk": "Unknown",

  "overview": "",

  "symptoms": [],

  "visual_analysis": {{
    "symptoms_detected": [],
    "affected_parts": [],
    "color_changes": [],
    "estimated_affected_area_percent": 0.0
  }},

  "differential_diagnosis": [
    {{
      "name": "Unknown",
      "probability": 0.0,
      "reason": ""
    }}
  ],

  "possible_causes": {{
    "primary": "",
    "secondary": []
  }},

  "immediate_actions": [],

  "organic_treatment": [],

  "chemical_treatment": [],

  "prevention": [],

  "monitoring": "",

  "metadata": {{}}
}}

============================================================
FIELD INSTRUCTIONS
============================================================

crop_type:
Identify the crop or plant if visually possible.
Otherwise return "Unknown".

plant_part:
Identify the visible plant part being analyzed.
Examples:
- leaf
- stem
- fruit
- flower
- root
- whole plant

health_status:
Use one of:
- Healthy
- At Risk
- Diseased
- Pest Infested
- Nutrient Deficient
- Unknown

disease_name:
For disease:
    give the most likely disease.

For pest:
    give the most likely pest.

For nutrient deficiency:
    give the likely nutrient deficiency.

For healthy or uncertain:
    return "Unknown".

confidence:
Decimal between 0.0 and 1.0.

Example:
94% = 0.94

severity:
Use:
- Very Low
- Low
- Moderate
- High
- Critical
- Unknown

disease_stage:
Use:
- None
- Early
- Early-Mid
- Mid
- Mid-Late
- Late
- Unknown

spread_risk:
Use:
- Very Low
- Low
- Moderate
- High
- Very High
- Unknown

============================================================
OVERVIEW
============================================================

overview:
Give a short farmer-friendly explanation of what the
image appears to show.

It should answer:

"What is happening to my plant?"

Keep it concise.

============================================================
SYMPTOMS
============================================================

symptoms:
List the important visible symptoms in simple language.

Examples:
- Yellow spots on leaves
- Brown circular lesions
- Leaf curling
- White powder-like growth
- Wilting

Only include symptoms actually supported by the image.

============================================================
VISUAL ANALYSIS
============================================================

symptoms_detected:
Detailed visible symptoms.

affected_parts:
Parts visibly affected.

color_changes:
Visible color changes.

estimated_affected_area_percent:
Estimate the visible affected area between 0 and 100.

If it cannot be estimated reliably, use 0.

============================================================
DIFFERENTIAL DIAGNOSIS
============================================================

Include possible alternative diagnoses only when there is
reasonable visual evidence.

Probability must be between 0.0 and 1.0.

Do not invent alternatives just to fill the list.

============================================================
POSSIBLE CAUSES
============================================================

primary:
Most likely cause based on the visual evidence.

secondary:
Other plausible causes.

Do not invent environmental conditions.

============================================================
IMMEDIATE ACTIONS
============================================================

Give practical steps the farmer should take immediately.

Examples:
- Remove severely affected leaves.
- Separate heavily affected plants.
- Avoid unnecessary overhead irrigation.
- Inspect nearby plants.

============================================================
ORGANIC TREATMENT
============================================================

Give reasonable organic or biological treatment options
when appropriate.

If not appropriate or uncertain:
return [].

============================================================
CHEMICAL TREATMENT
============================================================

Give general chemical treatment guidance only when
reasonably appropriate.

NEVER invent dosage.

If uncertain:
return [].

============================================================
PREVENTION
============================================================

Give practical steps that can reduce the chance of the
problem spreading or returning.

Examples:
- Remove infected plant debris.
- Improve field sanitation.
- Maintain proper plant spacing.
- Monitor new growth regularly.

============================================================
MONITORING
============================================================

Tell the farmer what to watch for over the next few days.

Examples:
- Check whether new spots appear.
- Monitor nearby plants.
- Watch for increasing leaf yellowing.
- Check whether the affected area is expanding.

Keep this concise and practical.

============================================================
LANGUAGE
============================================================

If language = "en":

All farmer-facing text must be in English.

If language = "hi":

All farmer-facing text must be in Hindi.

This includes:

- disease_name
- overview
- symptoms
- symptoms_detected
- affected_parts
- color_changes
- differential diagnosis reasons
- possible causes
- immediate actions
- organic treatment
- chemical treatment
- prevention
- monitoring

Keep the JSON keys EXACTLY as provided.

============================================================
HEALTHY PLANT
============================================================

If the plant appears healthy:

health_status = "Healthy"

disease_name = "Unknown"

severity = "Very Low"

disease_stage = "None"

spread_risk = "Very Low"

confidence should reflect the visual confidence.

immediate_actions = []

organic_treatment = []

chemical_treatment = []

============================================================
UNCLEAR IMAGE
============================================================

If the image is unclear:

health_status = "Unknown"

disease_name = "Unknown"

confidence = 0.0

severity = "Unknown"

disease_stage = "Unknown"

spread_risk = "Unknown"

overview should explain that the image is not clear enough
for reliable diagnosis.

Do not invent symptoms or treatments.

Return ONLY valid JSON.
"""


# ============================================================
# Normalize Model Response
# ============================================================

def normalize_disease_response(data: dict) -> dict:

    if not isinstance(data, dict):
        data = {}

    # --------------------------------------------------------
    # Basic fields
    # --------------------------------------------------------

    data["crop_type"] = str(
        data.get("crop_type") or "Unknown"
    )

    data["plant_part"] = str(
        data.get("plant_part") or "Unknown"
    )

    data["health_status"] = str(
        data.get("health_status") or "Unknown"
    )

    data["disease_name"] = str(
        data.get("disease_name") or "Unknown"
    )

    data["severity"] = str(
        data.get("severity") or "Unknown"
    )

    data["disease_stage"] = str(
        data.get("disease_stage") or "Unknown"
    )

    data["spread_risk"] = str(
        data.get("spread_risk") or "Unknown"
    )

    # --------------------------------------------------------
    # Farmer-friendly fields
    # --------------------------------------------------------

    data["overview"] = str(
        data.get("overview") or ""
    )

    symptoms = data.get("symptoms", [])

    if not isinstance(symptoms, list):
        symptoms = []

    data["symptoms"] = [
        str(item)
        for item in symptoms
        if item is not None
    ]

    prevention = data.get("prevention", [])

    if not isinstance(prevention, list):
        prevention = []

    data["prevention"] = [
        str(item)
        for item in prevention
        if item is not None
    ]

    data["monitoring"] = str(
        data.get("monitoring") or ""
    )

    # --------------------------------------------------------
    # Confidence
    # --------------------------------------------------------

    confidence = data.get(
        "confidence",
        0.0
    )

    try:
        confidence = float(confidence)
    except (TypeError, ValueError):
        confidence = 0.0

    data["confidence"] = max(
        0.0,
        min(1.0, confidence)
    )

    # --------------------------------------------------------
    # Visual Analysis
    # --------------------------------------------------------

    visual = data.get(
        "visual_analysis"
    )

    if not isinstance(visual, dict):
        visual = {}

    symptoms_detected = visual.get(
        "symptoms_detected",
        []
    )

    if not isinstance(
        symptoms_detected,
        list
    ):
        symptoms_detected = []

    visual["symptoms_detected"] = [
        str(item)
        for item in symptoms_detected
        if item is not None
    ]

    affected_parts = visual.get(
        "affected_parts",
        []
    )

    if not isinstance(
        affected_parts,
        list
    ):
        affected_parts = []

    visual["affected_parts"] = [
        str(item)
        for item in affected_parts
        if item is not None
    ]

    color_changes = visual.get(
        "color_changes",
        []
    )

    if not isinstance(
        color_changes,
        list
    ):
        color_changes = []

    visual["color_changes"] = [
        str(item)
        for item in color_changes
        if item is not None
    ]

    affected_area = visual.get(
        "estimated_affected_area_percent",
        0.0
    )

    try:
        affected_area = float(
            affected_area
        )
    except (TypeError, ValueError):
        affected_area = 0.0

    visual[
        "estimated_affected_area_percent"
    ] = max(
        0.0,
        min(100.0, affected_area)
    )

    data["visual_analysis"] = visual

    # --------------------------------------------------------
    # Differential Diagnosis
    # --------------------------------------------------------

    differential = data.get(
        "differential_diagnosis",
        []
    )

    if not isinstance(
        differential,
        list
    ):
        differential = []

    normalized_differential = []

    for item in differential:

        if not isinstance(item, dict):
            continue

        name = str(
            item.get("name") or "Unknown"
        )

        reason = str(
            item.get("reason") or ""
        )

        probability = item.get(
            "probability",
            0.0
        )

        try:
            probability = float(
                probability
            )
        except (TypeError, ValueError):
            probability = 0.0

        normalized_differential.append(
            {
                "name": name,
                "probability": max(
                    0.0,
                    min(1.0, probability)
                ),
                "reason": reason,
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

    if not isinstance(
        causes,
        dict
    ):
        causes = {}

    causes["primary"] = str(
        causes.get("primary") or ""
    )

    secondary = causes.get(
        "secondary",
        []
    )

    if not isinstance(
        secondary,
        list
    ):
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
        "immediate_actions",
        []
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
        "organic_treatment",
        []
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
        "chemical_treatment",
        []
    )

    if isinstance(
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

    # --------------------------------------------------------
    # Metadata
    # --------------------------------------------------------

    metadata = data.get(
        "metadata",
        {}
    )

    if not isinstance(
        metadata,
        dict
    ):
        metadata = {}

    data["metadata"] = metadata

    return data


# ============================================================
# Analyze Plant
# ============================================================

async def analyze_plant(
    image_bytes: bytes,
    content_type: str = "image/jpeg",
    language: str = "en"
):
    """
    Analyze a plant image using Groq + Qwen Vision.

    language:
        en = English
        hi = Hindi
    """

    start = time.time()

    # --------------------------------------------------------
    # Validate language
    # --------------------------------------------------------

    language = language.lower().strip()

    if language not in {
        "en",
        "hi"
    }:
        language = "en"

    # --------------------------------------------------------
    # Encode image
    # --------------------------------------------------------

    image_base64 = base64.b64encode(
        image_bytes
    ).decode("utf-8")

    # --------------------------------------------------------
    # Build prompt
    # --------------------------------------------------------

    user_prompt = USER_PROMPT_TEMPLATE.format(
        language=language
    )

    try:

        # ====================================================
        # Groq / Qwen Vision
        # ====================================================

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
                            "text": user_prompt
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": (
                                    f"data:{content_type};base64,"
                                    f"{image_base64}"
                                )
                            }
                        }
                    ]
                }
            ],

            temperature=0.3,

            max_tokens=1500,

            timeout=60
        )

        # ====================================================
        # Extract response
        # ====================================================

        result = (
            response
            .choices[0]
            .message
            .content
        )

        if not result:

            logger.error(
                "Groq returned empty disease response."
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Disease detection returned "
                    "an empty response."
                )
            )

        # ====================================================
        # Parse JSON
        # ====================================================

        try:

            data = json.loads(
                result
            )

        except json.JSONDecodeError:

            logger.error(
                "Groq returned invalid JSON: %s",
                result[:500]
            )

            raise HTTPException(
                status_code=502,
                detail=(
                    "Could not parse disease result. "
                    "Please retry."
                )
            )

        # ====================================================
        # Normalize
        # ====================================================

        data = normalize_disease_response(
            data
        )

        # ====================================================
        # Metadata
        # ====================================================

        prediction_time = int(
            (time.time() - start) * 1000
        )

        data["metadata"][
            "prediction_time_ms"
        ] = prediction_time

        data["metadata"][
            "language"
        ] = language

        # ====================================================
        # Logging
        # ====================================================

        logger.info(
            "Disease analysis completed "
            "in %sms | crop=%s | issue=%s | language=%s",
            prediction_time,
            data.get("crop_type"),
            data.get("disease_name"),
            language
        )

        return data

    # ========================================================
    # Rate Limit
    # ========================================================

    except RateLimitError:

        logger.warning(
            "Groq rate limit reached."
        )

        raise HTTPException(
            status_code=503,
            detail=(
                "Disease detection is busy. "
                "Please retry shortly."
            )
        )

    # ========================================================
    # API Error
    # ========================================================

    except APIError as e:

        logger.error(
            "Groq vision API error: %s",
            e
        )

        raise HTTPException(
            status_code=502,
            detail=(
                "Disease detection is temporarily "
                "unavailable."
            )
        )

    # ========================================================
    # HTTP Exception
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
            )
        )