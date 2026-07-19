import os
import json
import base64
import re

from groq import Groq


client = Groq(
    api_key=os.getenv("GROQ_API_KEY")
)


async def analyze_leaf(image_path: str):

    with open(image_path, "rb") as image_file:
        image_base64 = base64.b64encode(
            image_file.read()
        ).decode("utf-8")


    response = client.chat.completions.create(

        model="qwen/qwen3.6-27b",

        response_format={
            "type": "json_object"
        },

        messages=[
            {
                "role": "system",
                "content": """
You are a plant disease detection AI.

Rules:
- Analyze only the leaf.
- Ignore insects, background, soil.
- If no disease is visible return disease_name as Unknown.
- Never explain.
- Return ONLY JSON.
"""
            },

            {
                "role": "user",
                "content":[

                    {
                        "type":"text",
                        "text":"""
Analyze this leaf image.

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
}
"""
                    },

                    {
                        "type":"image_url",
                        "image_url":{
                            "url":
                            f"data:image/jpeg;base64,{image_base64}"
                        }
                    }

                ]
            }
        ],

        temperature=0.1
    )


    result = response.choices[0].message.content


    print("GROQ RESPONSE:")
    print(result)


    return json.loads(result)