import os, json, base64
from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException
import logging

logger = logging.getLogger("crop_backend")

client = AsyncGroq(api_key=os.getenv("GROQ_API_KEY"))

SYSTEM_PROMPT = """You are a plant disease detection AI.

Rules:
- Analyze only the leaf.
- Ignore insects, background, soil.
- If no disease is visible return disease_name as Unknown.
- Never explain.
- Return ONLY JSON."""

USER_PROMPT = """Analyze this leaf image.

Return exactly:

{
"crop_type":"",
"disease_name":"",
"confidence":0,
"severity":0,
"disease_stage":"",
"mortality_rate":"",
"overview":"",
"weather_conditions":{
"temperature":"",
"humidity":"",
"ph":""
},
"precautions":[],
"organic_cure":[],
"chemical_cure":[]
}"""


async def analyze_leaf(image_bytes: bytes):
    image_base64 = base64.b64encode(image_bytes).decode("utf-8")
    result = None
    try:
        response = await client.chat.completions.create(
            model="qwen/qwen3.6-27b",
            response_format={"type": "json_object"},
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": [
                    {"type": "text", "text": USER_PROMPT},
                    {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{image_base64}"}},
                ]},
            ],
            temperature=0.1,
            timeout=60,
        )
        result = response.choices[0].message.content
        return json.loads(result)

    except RateLimitError:
        raise HTTPException(503, "Disease detection busy, please retry shortly.")
    except APIError as e:
        logger.error(f"Groq vision error: {e}")
        raise HTTPException(502, "Disease detection temporarily unavailable.")
    except json.JSONDecodeError:
        logger.error(f"Model returned non-JSON: {result[:200] if result else 'no response'}")
        raise HTTPException(502, "Could not parse disease result, please retry.")