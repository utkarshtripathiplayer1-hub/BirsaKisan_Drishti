import logging
from typing import Optional

import requests

from core.config import (
    BHASHINI_INFERENCE_KEY,
    BHASHINI_USER_ID,
    BHASHINI_UDYAT_API_KEY,
)


logger = logging.getLogger("ai_core.bhashini")


BHASHINI_TRANSLATION_URL = (
    "https://inference.api.bhashini.gov.in/"
    "inference/text/translation/v2"
)


class BhashiniError(Exception):
    """Raised when a Bhashini operation fails."""


def _build_headers() -> dict:
    """
    Build headers for Bhashini requests.

    The inference key is required for the translation
    endpoint currently being used by the project.
    """

    if not BHASHINI_INFERENCE_KEY:
        raise BhashiniError(
            "Bhashini inference key is not configured."
        )

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"Bearer {BHASHINI_INFERENCE_KEY}",
    }

    if BHASHINI_USER_ID:
        headers["userID"] = BHASHINI_USER_ID

    if BHASHINI_UDYAT_API_KEY:
        headers["ulcaApiKey"] = BHASHINI_UDYAT_API_KEY

    return headers


def _normalize_language(language: str) -> str:
    """
    Normalize an application language code.

    Examples:
        en-IN -> en
        hi-IN -> hi
        gu-IN -> gu
    """

    if not language:
        raise BhashiniError(
            "Language code cannot be empty."
        )

    return language.lower().split("-")[0]


def translate_text(
    text: str,
    source_language: str,
    target_language: str,
    timeout: int = 30,
) -> str:
    """
    Translate text using Bhashini.

    This function only communicates with Bhashini.
    Fallback to Sarvam is handled by language_service.py.
    """

    if not text:
        return ""

    source_language = _normalize_language(
        source_language
    )

    target_language = _normalize_language(
        target_language
    )

    if source_language == target_language:
        return text

    headers = _build_headers()

    payload = {
        "processingLanguage": source_language,
        "input": [
            {
                "source": text,
            }
        ],
        "config": {
            "translation": {
                "sourceLanguage": source_language,
                "targetLanguage": target_language,
            }
        },
    }

    try:
        response = requests.post(
            BHASHINI_TRANSLATION_URL,
            headers=headers,
            json=payload,
            timeout=timeout,
        )

    except requests.RequestException as exc:
        logger.error(
            "Bhashini translation request failed: %s",
            exc,
        )

        raise BhashiniError(
            "Bhashini translation request failed."
        ) from exc

    if response.status_code != 200:
        logger.error(
            "Bhashini translation failed. "
            "status=%s response=%s",
            response.status_code,
            response.text[:500],
        )

        raise BhashiniError(
            f"Bhashini translation failed "
            f"with status {response.status_code}."
        )

    try:
        data = response.json()

    except ValueError as exc:
        logger.error(
            "Bhashini returned invalid JSON."
        )

        raise BhashiniError(
            "Bhashini returned an invalid response."
        ) from exc

    output = data.get("output")

    if (
        not isinstance(output, list)
        or not output
        or not isinstance(output[0], dict)
    ):
        logger.error(
            "Unexpected Bhashini translation response: %s",
            data,
        )

        raise BhashiniError(
            "Bhashini returned an unexpected translation response."
        )

    translated_text = output[0].get("target")

    if not translated_text:
        raise BhashiniError(
            "Bhashini returned an empty translation."
        )

    return translated_text


def translate_to_english(
    text: str,
    source_language: str,
) -> str:
    """
    Translate supported language → English.
    """

    return translate_text(
        text=text,
        source_language=source_language,
        target_language="en",
    )


def translate_from_english(
    text: str,
    target_language: str,
) -> str:
    """
    Translate English → user's preferred language.
    """

    return translate_text(
        text=text,
        source_language="en",
        target_language=target_language,
    )