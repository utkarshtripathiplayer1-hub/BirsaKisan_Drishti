import logging
import re

from fastapi import HTTPException
from groq import AsyncGroq, APIError, RateLimitError

from core.config import GROQ_API_KEY, GROQ_MODEL


logger = logging.getLogger("ai_core")

client = AsyncGroq(
    api_key=GROQ_API_KEY
)


async def ask_groq(messages: list):
    try:
        response = await client.chat.completions.create(
            model=GROQ_MODEL,
            messages=messages,
            timeout=30,
            max_tokens=1024,
        )

        content = response.choices[0].message.content or ""

        # Remove <think>...</think> blocks if the model returns them
        content = re.sub(
            r"<think>.*?</think>",
            "",
            content,
            flags=re.DOTALL | re.IGNORECASE,
        )

        # Remove accidental reasoning prefixes
        content = re.sub(
            r"^\s*(analysis|reasoning)\s*:\s*",
            "",
            content,
            flags=re.IGNORECASE,
        )

        return content.strip()

    except RateLimitError:
        logger.warning("Groq rate limit reached")

        raise HTTPException(
            status_code=503,
            detail="AI service busy, please retry in a moment.",
        )

    except APIError as e:
        logger.error(f"Groq API error: {e}")

        raise HTTPException(
            status_code=502,
            detail="AI service temporarily unavailable.",
        )

    except Exception as e:
        logger.exception(f"Unexpected Groq error: {e}")

        raise HTTPException(
            status_code=500,
            detail="An unexpected AI service error occurred.",
        )