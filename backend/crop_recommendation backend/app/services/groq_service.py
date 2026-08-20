import os
import json
import base64
import time
import logging

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException

logger = logging.getLogger("crop_backend")

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL = os.getenv("GROQ_MODEL", "qwen/qwen3.6-27b")

client = AsyncGroq(api_key=GROQ_API_KEY)


SYSTEM_PROMPT = """You are Birsa-Kisan Drishti AI, an expert agricultural assistant
(plant pathology, agronomy, entomology, soil science, horticulture).

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

For any field that cannot be determined from the image, use null.
Never guess chemical dosages, disease biology, or other information that cannot
be established from the image.

Return ONLY valid JSON.
No markdown.
No code blocks.
No text outside JSON."""


USER_PROMPT = """Analyze this plant image and return exactly this JSON:

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
  "chemical_treatment": null
}

Enums:

health_status:
Healthy | Diseased | Pest Infested | Nutrient Deficient | Abiotic Stress | Unknown

severity:
Very Low | Low | Moderate | High | Critical

disease_stage:
Early | Early-Mid | Mid | Mid-Late | Late | Unknown

spread_risk:
Very Low | Low | Moderate | High | Very High"""


async def analyze_plant(
    image_bytes: bytes,
    content_type: str = "image/jpeg",
):
    image_base64 = base64.b64encode(image_bytes).decode("utf-8")

    result = None
    start = time.time()

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

        result = response.choices[0].message.content

        if not result:
            logger.error("Qwen returned an empty response")
            raise HTTPException(
                502,
                "Disease detection returned an empty response.",
            )

        data = json.loads(result)

        data.setdefault("metadata", {})
        data["metadata"]["prediction_time_ms"] = int(
            (time.time() - start) * 1000
        )

        return data

    except RateLimitError:
        raise HTTPException(
            503,
            "Disease detection busy, please retry shortly.",
        )

    except APIError as e:
        logger.error(f"Groq vision error: {e}")

        raise HTTPException(
            502,
            "Disease detection temporarily unavailable.",
        )

    except json.JSONDecodeError:
        preview = result[:200] if result else "no response"

        logger.error(
            f"Qwen returned invalid JSON: {preview}"
        )

        raise HTTPException(
            502,
            "Could not parse disease result, please retry.",
        )

    except HTTPException:
        raise

    except Exception as e:
        logger.exception(
            f"Unexpected disease detection error: {e}"
        )

        raise HTTPException(
            500,
            "Unexpected disease detection error.",
        )