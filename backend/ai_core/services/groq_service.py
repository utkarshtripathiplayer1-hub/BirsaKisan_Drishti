import logging
import re

from groq import AsyncGroq, APIError, RateLimitError
from fastapi import HTTPException

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

        # --------------------------------------------------
        # Remove model reasoning if it is returned
        # --------------------------------------------------
        content = re.sub(
            r"<think>.*?</think>",
            "",
            content,
            flags=re.DOTALL | re.IGNORECASE,
        ).strip()

        # --------------------------------------------------
        # Remove accidental reasoning markers
        # --------------------------------------------------
        content = re.sub(
            r"^\s*(analysis|reasoning):\s*",
            "",
            content,
            flags=re.IGNORECASE,
        ).strip()

        return content

    except RateLimitError:

        raise HTTPException(
            status_code=503,
            detail="AI service busy, please retry in a moment.",
        )

    except APIError as e:

        logger.error(
            f"Groq API error: {e}"
        )

        raise HTTPException(
            status_code=502,
            detail="AI service temporarily unavailable.",
        )