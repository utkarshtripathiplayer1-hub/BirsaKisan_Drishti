import os
import json
import base64
import time
import logging

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException


logger = logging.getLogger("crop_backend")


GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL = os.getenv(
    "GROQ_MODEL",
    "qwen/qwen3.6-27b"
)


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

2. disease_name:
   Identify the most likely visible disease.
   If the plant appears healthy, use "Unknown".
   If evidence is insufficient, use "Unknown".

3. confidence:
   Number between 0.0 and 1.0.

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
                            }
                        }

                    ]
                }
            ],

            temperature=0.3,

            max_tokens=1200,

            timeout=60
        )

        result = response.choices[0].message.content

        if not result:

            logger.error(
                "Groq returned empty response"
            )

            raise HTTPException(
                status_code=502,
                detail="Disease detection returned an empty response."
            )

        data = json.loads(result)

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

        return data

    except RateLimitError:

        raise HTTPException(
            status_code=503,
            detail="Disease detection busy, please retry shortly."
        )

    except APIError as e:

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
            detail="Could not parse disease result."
        )

    except HTTPException:
        raise

    except Exception as e:

        logger.exception(
            "Unexpected disease detection error: %s",
            e
        )

        raise HTTPException(
            status_code=500,
            detail="Unexpected disease detection error."
        )