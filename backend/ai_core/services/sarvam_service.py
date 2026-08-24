import asyncio
import logging

from sarvamai import SarvamAI

from core.config import SARVAM_API_KEY


logger = logging.getLogger("ai_core.sarvam")


# ============================================================
# Sarvam client
# ============================================================

client = SarvamAI(
    api_subscription_key=SARVAM_API_KEY
)


# ============================================================
# Supported languages
# ============================================================

LANGUAGE_MAP = {
    "en": "en-IN",
    "hi": "hi-IN",
    "mr": "mr-IN",
    "ta": "ta-IN",
    "te": "te-IN",
    "kn": "kn-IN",
    "ml": "ml-IN",
    "gu": "gu-IN",
    "pa": "pa-IN",
    "bn": "bn-IN",
    "or": "or-IN",
}


LANGUAGE_NAMES = {
    "en": "English",
    "hi": "Hindi",
    "mr": "Marathi",
    "ta": "Tamil",
    "te": "Telugu",
    "kn": "Kannada",
    "ml": "Malayalam",
    "gu": "Gujarati",
    "pa": "Punjabi",
    "bn": "Bengali",
    "or": "Odia",
}


class SarvamError(Exception):
    """
    Raised when a Sarvam operation fails.
    """


# ============================================================
# Helpers
# ============================================================

def normalize_language(language: str) -> str:
    """
    Convert language codes such as:

        hi-IN -> hi
        gu-IN -> gu
        en -> en

    into the application's internal language format.
    """

    if not language:
        raise SarvamError(
            "Language code cannot be empty."
        )

    language = language.lower().strip()

    language = language.split("-")[0]

    if language not in LANGUAGE_MAP:
        raise SarvamError(
            f"Unsupported Sarvam language: {language}"
        )

    return language


# ============================================================
# Translation
# ============================================================

async def translate_text(
    text: str,
    source_language: str,
    target_language: str,
) -> str:
    """
    Translate text using Sarvam AI.

    Sarvam's SDK call is synchronous, so it is executed
    in a worker thread to avoid blocking FastAPI's event loop.

    Fallback handling is NOT performed here.
    language_service.py controls provider fallback.
    """

    if not text:
        return ""

    source_language = normalize_language(
        source_language
    )

    target_language = normalize_language(
        target_language
    )

    if source_language == target_language:
        return text

    try:

        response = await asyncio.to_thread(
            client.text.translate,
            input=text,
            source_language_code=LANGUAGE_MAP[source_language],
            target_language_code=LANGUAGE_MAP[target_language],
            speaker_gender="Male",
        )

    except Exception as exc:

        logger.error(
            "Sarvam translation failed: %s",
            exc,
        )

        raise SarvamError(
            "Sarvam translation request failed."
        ) from exc

    translated_text = getattr(
        response,
        "translated_text",
        None,
    )

    if not translated_text:

        logger.error(
            "Sarvam returned an empty translation."
        )

        raise SarvamError(
            "Sarvam returned an empty translation."
        )

    return translated_text


async def translate_to_english(
    text: str,
    source_language: str,
) -> str:
    """
    Translate user's language → English.
    """

    return await translate_text(
        text=text,
        source_language=source_language,
        target_language="en",
    )


async def translate_from_english(
    text: str,
    target_language: str,
) -> str:
    """
    Translate English → user's preferred language.
    """

    return await translate_text(
        text=text,
        source_language="en",
        target_language=target_language,
    )