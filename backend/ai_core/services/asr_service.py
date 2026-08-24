import asyncio
import logging
import os
from typing import Optional

from services import bhashini_service
from services import sarvam_service


logger = logging.getLogger("ai_core.asr")


class ASRServiceError(Exception):
    """
    Raised when all available speech-to-text providers fail.
    """


# ============================================================
# Sarvam configuration
# ============================================================

SARVAM_STT_MODEL = "saaras:v3"


# ============================================================
# Language helpers
# ============================================================

def _normalize_language(language: Optional[str]) -> Optional[str]:
    """
    Normalize language codes.

    Examples:
        hi-IN -> hi
        gu-IN -> gu
        en-IN -> en
        None -> None
    """

    if not language:
        return None

    return language.lower().strip().split("-")[0]


def _sarvam_language_code(
    language: Optional[str],
) -> str:
    """
    Convert our internal language code to Sarvam's
    BCP-47 language code.

    If no language is supplied, use 'unknown' so Sarvam
    can automatically detect the language.
    """

    if not language:
        return "unknown"

    language = _normalize_language(language)

    return sarvam_service.LANGUAGE_MAP.get(
        language,
        "unknown",
    )


# ============================================================
# Public ASR function
# ============================================================

async def speech_to_text(
    audio_path: str,
    language: Optional[str] = None,
) -> dict:
    """
    Convert speech audio into text.

    Provider order:

        1. Bhashini
        2. Sarvam fallback

    Returns:

        {
            "transcript": "...",
            "language": "hi",
            "provider": "bhashini"
        }

    or:

        {
            "transcript": "...",
            "language": "hi",
            "provider": "sarvam"
        }
    """

    if not audio_path:
        raise ASRServiceError(
            "Audio path is required."
        )

    if not os.path.isfile(audio_path):
        raise ASRServiceError(
            "Audio file does not exist."
        )

    normalized_language = _normalize_language(
        language
    )

    # --------------------------------------------------------
    # Provider 1: Bhashini
    # --------------------------------------------------------

    try:

        logger.info(
            "Attempting ASR using Bhashini."
        )

        result = await _bhashini_speech_to_text(
            audio_path=audio_path,
            language=normalized_language,
        )

        if not result:
            raise ASRServiceError(
                "Bhashini returned an empty ASR result."
            )

        transcript = result.get("transcript")

        if not transcript:
            raise ASRServiceError(
                "Bhashini returned no transcript."
            )

        detected_language = _normalize_language(
            result.get("language")
            or normalized_language
        )

        return {
            "transcript": transcript,
            "language": detected_language,
            "provider": "bhashini",
        }

    except Exception as bhashini_error:

        logger.warning(
            "Bhashini ASR failed: %s. "
            "Using Sarvam fallback.",
            bhashini_error,
        )

    # --------------------------------------------------------
    # Provider 2: Sarvam fallback
    # --------------------------------------------------------

    try:

        logger.info(
            "Attempting ASR using Sarvam Saaras."
        )

        result = await _sarvam_speech_to_text(
            audio_path=audio_path,
            language=normalized_language,
        )

        transcript = result.get("transcript")

        if not transcript:
            raise ASRServiceError(
                "Sarvam returned no transcript."
            )

        detected_language = _normalize_language(
            result.get("language")
            or normalized_language
        )

        return {
            "transcript": transcript,
            "language": detected_language,
            "provider": "sarvam",
        }

    except Exception as sarvam_error:

        logger.error(
            "Sarvam ASR fallback failed: %s",
            sarvam_error,
        )

        raise ASRServiceError(
            "Both Bhashini and Sarvam speech-to-text "
            "services are currently unavailable."
        ) from sarvam_error


# ============================================================
# Bhashini ASR adapter
# ============================================================

async def _bhashini_speech_to_text(
    audio_path: str,
    language: Optional[str] = None,
) -> dict:
    """
    Adapter for Bhashini ASR.

    The Bhashini provider currently does not yet expose
    an ASR method in our new bhashini_service.py.

    Once the verified Bhashini ASR API is implemented there,
    this adapter will call it.

    Keeping this boundary here means the rest of the
    application does not need to change.
    """

    bhashini_asr = getattr(
        bhashini_service,
        "speech_to_text",
        None,
    )

    if bhashini_asr is None:
        raise ASRServiceError(
            "Bhashini ASR provider is not configured yet."
        )

    if asyncio.iscoroutinefunction(bhashini_asr):

        return await bhashini_asr(
            audio_path=audio_path,
            language=language,
        )

    return await asyncio.to_thread(
        bhashini_asr,
        audio_path,
        language,
    )


# ============================================================
# Sarvam ASR adapter
# ============================================================

async def _sarvam_speech_to_text(
    audio_path: str,
    language: Optional[str] = None,
) -> dict:
    """
    Speech-to-text using Sarvam Saaras v3.

    Sarvam automatically detects the language when
    language_code='unknown'.
    """

    language_code = _sarvam_language_code(
        language
    )

    def transcribe():
        with open(audio_path, "rb") as audio_file:

            return sarvam_service.client.speech_to_text.transcribe(
                file=audio_file,
                model=SARVAM_STT_MODEL,
                mode="transcribe",
                language_code=language_code,
            )

    try:

        response = await asyncio.to_thread(
            transcribe
        )

    except Exception as exc:

        logger.error(
            "Sarvam Saaras transcription failed: %s",
            exc,
        )

        raise ASRServiceError(
            "Sarvam speech-to-text request failed."
        ) from exc

    transcript = getattr(
        response,
        "transcript",
        None,
    )

    detected_language = getattr(
        response,
        "language_code",
        None,
    )

    if not transcript:
        raise ASRServiceError(
            "Sarvam returned an empty transcript."
        )

    return {
        "transcript": transcript,
        "language": detected_language,
    }