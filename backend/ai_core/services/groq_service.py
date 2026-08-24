import logging
import re
from typing import Any

from groq import (
    APIError,
    RateLimitError,
    AsyncGroq,
)

from core.config import (
    GROQ_API_KEY,
    GROQ_MODEL,
)


logger = logging.getLogger("ai_core.groq")


# ============================================================
# Groq client
# ============================================================

client = AsyncGroq(
    api_key=GROQ_API_KEY
)


class GroqServiceError(Exception):
    """
    Raised when the Groq/Qwen service cannot generate a response.
    """


# ============================================================
# Response cleaning
# ============================================================

def clean_model_response(
    content: str,
) -> str:
    """
    Remove accidental model reasoning markers before the
    response is returned to the user.
    """

    if not content:
        return ""

    # Remove <think>...</think> blocks.
    content = re.sub(
        r"<think>.*?</think>",
        "",
        content,
        flags=re.DOTALL | re.IGNORECASE,
    )

    # Remove accidental reasoning prefixes.
    content = re.sub(
        r"^\s*(analysis|reasoning):\s*",
        "",
        content,
        flags=re.IGNORECASE,
    )

    return content.strip()


# ============================================================
# Main generation function
# ============================================================

async def generate_response(
    messages: list[dict[str, Any]],
    max_tokens: int = 1024,
    temperature: float = 0.3,
) -> str:
    """
    Generate a response using Groq/Qwen.

    This service only communicates with Groq.
    It does NOT handle:

    - language detection
    - translation
    - agriculture
    - apiculture
    - weather
    - crop recommendations
    - disease detection
    - conversation storage
    - safety/context decisions
    """

    if not messages:
        raise GroqServiceError(
            "At least one message is required."
        )

    try:

        response = await client.chat.completions.create(
            model=GROQ_MODEL,
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
            timeout=30,
        )

    except RateLimitError as exc:

        logger.warning(
            "Groq rate limit reached: %s",
            exc,
        )

        raise GroqServiceError(
            "AI service is currently busy. "
            "Please try again in a moment."
        ) from exc

    except APIError as exc:

        logger.error(
            "Groq API error: %s",
            exc,
        )

        raise GroqServiceError(
            "AI service is temporarily unavailable."
        ) from exc

    except Exception as exc:

        logger.exception(
            "Unexpected Groq error."
        )

        raise GroqServiceError(
            "Unable to generate an AI response."
        ) from exc

    try:

        content = (
            response
            .choices[0]
            .message
            .content
            or ""
        )

    except (
        AttributeError,
        IndexError,
    ) as exc:

        logger.error(
            "Unexpected Groq response format."
        )

        raise GroqServiceError(
            "AI service returned an invalid response."
        ) from exc

    content = clean_model_response(
        content
    )

    if not content:

        raise GroqServiceError(
            "AI service returned an empty response."
        )

    return content


# ============================================================
# Backward-compatible helper
# ============================================================

async def ask_groq(
    messages: list[dict[str, Any]],
) -> str:
    """
    Compatibility wrapper for code that still calls
    ask_groq().
    """

    return await generate_response(
        messages=messages
    )