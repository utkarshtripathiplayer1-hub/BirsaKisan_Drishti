import os
import json
import base64

from groq import Groq

client = Groq(
    api_key=os.getenv("GROQ_API_KEY")
)


def analyze_leaf(image_path: str):

    with open(image_path, "rb") as image_file:
        image_base64 = base64.b64encode(
            image_file.read()
        ).decode("utf-8")

    response = client.chat.completions.create(

        model="qwen/qwen3.6-27b",

        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": """
You are an expert plant pathologist.

Your task is to diagnose diseases from crop LEAF images only.

Ignore the background, branches, sky, soil, and any other objects.

Focus only on the visible leaf.

Identify:
- Crop type in crop type give similar names of that crop .
- Disease name
- Confidence (0-100)
- Severity (0-100)
- Disease stage
- Overview
- Organic cure
- Chemical cure
- Precautions
-Mortaility rate
If uncertain, say "Unknown" instead of guessing.
return healthy is healthy
Return ONLY valid JSON.

{
  "crop_type": "",
  "disease_name": "",
  "confidence": 0,
  "severity": 0,
  "disease_stage": "",
  "mortality_rate": "",
  "overview": "",
  "weather_conditions": {
    "temperature": "",
    "humidity": "",
    "ph": ""
  },
  "precautions": [],
  "organic_cure": [],
  "chemical_cure": []
}

Do not explain.
Do not use markdown.
Do not wrap the JSON in ``` blocks.
"""
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{image_base64}"
                        }
                    }
                ]
            }
        ],

        temperature=0.2
    )

    result = response.choices[0].message.content

    return json.loads(result)