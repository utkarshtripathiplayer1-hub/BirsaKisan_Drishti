import asyncio
import base64
import logging
import os
from typing import Optional

from services import bhashini_service
from services import sarvam_service


logger = logging.getLogger("ai_core.tts")


class TTSServiceError(Exception):
    """
    Raised when all available text-to-speech providers fail.
    """


# ============================================================
# Helpers
# ============================================================

def normalize_language(language: str) -> str:
    """
    Normalize language codes.

    Examples:
        hi-IN -> hi
        gu-IN -> gu
        en -> en
    """

    if not language:
        raise TTSServiceError(
            "Language code is required."
        )

    normalized = (
        language
        .lower()
        .strip()
        .split("-")[0]
    )

    if normalized not in sarvam_service.LANGUAGE_MAP:
        raise TTSServiceError(
            f"Unsupported TTS language: {language}"
        )

    return normalized


def _ensure_output_directory(output_file: str) -> None:
    """
    Create the output directory if it doesn't exist.
    """

    directory = os.path.dirname(
        os.path.abspath(output_file)
    )

    os.makedirs(
        directory,
        exist_ok=True,
    )


# ============================================================
# Public TTS function
# ============================================================

async def text_to_speech(
    text: str,
    language: str,
    output_file: str,
) -> dict:
    """
    Convert text to speech.

    Provider order:

        1. Bhashini
        2. Sarvam fallback

    Returns:

        {
            "output_file": "...",
            "provider": "bhashini"
        }

    or:

        {
            "output_file": "...",
            "provider": "sarvam"
        }
    """

    if not text or not text.strip():
        raise TTSServiceError(
            "Text is required for TTS."
        )

    if not output_file:
        raise TTSServiceError(
            "Output file path is required."
        )

    language = normalize_language(
        language
    )

    _ensure_output_directory(
        output_file
    )

    # --------------------------------------------------------
    # Provider 1: Bhashini
    # --------------------------------------------------------

    try:

        logger.info(
            "Attempting TTS using Bhashini: %s",
            language,
        )

        result = await _bhashini_text_to_speech(
            text=text,
            language=language,
            output_file=output_file,
        )

        if result:
            return {
                "output_file": result,
                "provider": "bhashini",
            }

        raise TTSServiceError(
            "Bhashini returned no audio."
        )

    except Exception as bhashini_error:

        logger.warning(
            "Bhashini TTS failed: %s. "
            "Using Sarvam fallback.",
            bhashini_error,
        )

    # --------------------------------------------------------
    # Provider 2: Sarvam fallback
    # --------------------------------------------------------

    try:

        logger.info(
            "Attempting TTS using Sarvam: %s",
            language,
        )

        result = await _sarvam_text_to_speech(
            text=text,
            language=language,
            output_file=output_file,
        )

        return {
            "output_file": result,
            "provider": "sarvam",
        }

    except Exception as sarvam_error:

        logger.error(
            "Sarvam TTS fallback failed: %s",
            sarvam_error,
        )

        raise TTSServiceError(
            "Both Bhashini and Sarvam text-to-speech "
            "services are currently unavailable."
        ) from sarvam_error


# ============================================================
# Bhashini TTS adapter
# ============================================================

async def _bhashini_text_to_speech(
    text: str,
    language: str,
    output_file: str,
) -> Optional[str]:
    """
    Adapter for Bhashini TTS.

    The exact Bhashini TTS provider implementation will be
    connected once the verified Bhashini TTS API contract
    is added to bhashini_service.py.
    """

    bhashini_tts = getattr(
        bhashini_service,
        "text_to_speech",
        None,
    )

    if bhashini_tts is None:
        raise TTSServiceError(
            "Bhashini TTS provider is not configured yet."
        )

    if asyncio.iscoroutinefunction(bhashini_tts):

        result = await bhashini_tts(
            text=text,
            language=language,
            output_file=output_file,
        )

    else:

        result = await asyncio.to_thread(
            bhashini_tts,
            text,
            language,
            output_file,
        )

    if not result:
        raise TTSServiceError(
            "Bhashini TTS returned no output."
        )

    return result


# ============================================================
# Sarvam TTS
# ============================================================

async def _sarvam_text_to_speech(
    text: str,
    language: str,
    output_file: str,
) -> str:
    """
    Convert text to speech using Sarvam AI.

    Sarvam returns audio as base64, which we decode and
    write to the requested output file.
    """

    language_code = sarvam_service.LANGUAGE_MAP.get(
        language
    )

    if not language_code:
        raise TTSServiceError(
            f"Sarvam does not support TTS language: {language}"
        )

    def generate_audio():

        return sarvam_service.client.text_to_speech.convert(
            text=text,
            target_language_code=language_code,
        )

    try:

        response = await asyncio.to_thread(
            generate_audio
        )

    except Exception as exc:

        logger.error(
            "Sarvam TTS request failed: %s",
            exc,
        )

        raise TTSServiceError(
            "Sarvam TTS request failed."
        ) from exc

    audios = getattr(
        response,
        "audios",
        None,
    )

    if not audios:
        raise TTSServiceError(
            "Sarvam returned no audio."
        )

    audio_base64 = audios[0]

    if not audio_base64:
        raise TTSServiceError(
            "Sarvam returned empty audio."
        )

    try:

        audio_bytes = base64.b64decode(
            audio_base64
        )

    except Exception as exc:

        logger.error(
            "Failed to decode Sarvam audio: %s",
            exc,
        )

        raise TTSServiceError(
            "Invalid audio returned by Sarvam."
        ) from exc

    try:

        with open(
            output_file,
            "wb",
        ) as audio_file:

            audio_file.write(
                audio_bytes
            )

    except OSError as exc:

        logger.error(
            "Failed to save generated audio: %s",
            exc,
        )

        raise TTSServiceError(
            "Unable to save generated audio."
        ) from exc

    return output_file