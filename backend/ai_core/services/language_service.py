import logging

from services import bhashini_service
from services import sarvam_service


logger = logging.getLogger("ai_core.language")


class LanguageServiceError(Exception):
    """
    Raised when all available language providers fail.
    """


# ============================================================
# Supported languages
# ============================================================

SUPPORTED_LANGUAGES = {
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


def normalize_language(language: str) -> str:
    """
    Normalize language codes.

    Examples:

        hi-IN -> hi
        gu-IN -> gu
        en -> en
    """

    if not language:
        raise LanguageServiceError(
            "Language code is required."
        )

    normalized = language.lower().strip().split("-")[0]

    if normalized not in SUPPORTED_LANGUAGES:
        raise LanguageServiceError(
            f"Unsupported language: {language}"
        )

    return normalized


def is_supported_language(language: str) -> bool:
    """
    Check whether a language is supported.
    """

    if not language:
        return False

    normalized = language.lower().strip().split("-")[0]

    return normalized in SUPPORTED_LANGUAGES


# ============================================================
# Translation
# ============================================================

async def translate(
    text: str,
    source_language: str,
    target_language: str,
) -> str:
    """
    Translate text using:

        1. Bhashini
        2. Sarvam fallback

    The caller does not need to know which provider
    actually performed the translation.
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

    # --------------------------------------------------------
    # Provider 1: Bhashini
    # --------------------------------------------------------

    try:

        logger.info(
            "Translation attempt using Bhashini: %s -> %s",
            source_language,
            target_language,
        )

        return await _bhashini_translate(
            text=text,
            source_language=source_language,
            target_language=target_language,
        )

    except Exception as bhashini_error:

        logger.warning(
            "Bhashini translation failed: %s. "
            "Trying Sarvam fallback.",
            bhashini_error,
        )

    # --------------------------------------------------------
    # Provider 2: Sarvam fallback
    # --------------------------------------------------------

    try:

        logger.info(
            "Translation attempt using Sarvam fallback: "
            "%s -> %s",
            source_language,
            target_language,
        )

        return await sarvam_service.translate_text(
            text=text,
            source_language=source_language,
            target_language=target_language,
        )

    except Exception as sarvam_error:

        logger.error(
            "Sarvam translation fallback failed: %s",
            sarvam_error,
        )

        raise LanguageServiceError(
            "Both Bhashini and Sarvam translation services "
            "are currently unavailable."
        ) from sarvam_error


async def _bhashini_translate(
    text: str,
    source_language: str,
    target_language: str,
) -> str:
    """
    Run Bhashini translation.

    Bhashini's current provider implementation is
    synchronous, so execute it in a worker thread.
    """

    import asyncio

    return await asyncio.to_thread(
        bhashini_service.translate_text,
        text,
        source_language,
        target_language,
    )


# ============================================================
# Convenience functions
# ============================================================

async def translate_to_english(
    text: str,
    source_language: str,
) -> str:
    """
    Translate any supported Indian language → English.
    """

    return await translate(
        text=text,
        source_language=source_language,
        target_language="en",
    )


async def translate_from_english(
    text: str,
    target_language: str,
) -> str:
    """
    Translate English → farmer's preferred language.
    """

    return await translate(
        text=text,
        source_language="en",
        target_language=target_language,
    )


# ============================================================
# Language information
# ============================================================

def get_language_name(language: str) -> str:
    """
    Return human-readable language name.
    """

    normalized = normalize_language(language)

    return SUPPORTED_LANGUAGES[normalized]