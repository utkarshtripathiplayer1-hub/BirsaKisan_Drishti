import logging

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException

from core.config import GROQ_API_KEY, GROQ_MODEL

logger = logging.getLogger("ai_core")

client = AsyncGroq(api_key=GROQ_API_KEY)


async def ask_groq(messages: list):
    try:
        response = await client.chat.completions.create(
            model=GROQ_MODEL,
            messages=messages,
            timeout=30,
            max_tokens=1024,
        )

        return response.choices[0].message.content

    except RateLimitError:
        raise HTTPException(
            503,
            "AI service busy, please retry in a moment.",
        )

    except APIError as e:
        logger.error(f"Groq API error: {e}")
        raise HTTPException(
            502,
            "AI service temporarily unavailable.",
        )