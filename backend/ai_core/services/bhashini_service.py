import requests

from core.config import BHASHINI_INFERENCE_KEY


BHASHINI_URL = (
    "https://inference.api.bhashini.gov.in/"
    "inference/text/translation/v2"
)


def translate_text(
    text: str,
    source_language: str,
    target_language: str
) -> str:
    """
    Generic translation function using Bhashini.
    """

    try:

        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": f"Bearer {BHASHINI_INFERENCE_KEY}"
        }

        payload = {
            "processingLanguage": source_language,
            "input": [
                {
                    "source": text
                }
            ],
            "config": {
                "translation": {
                    "sourceLanguage": source_language,
                    "targetLanguage": target_language
                }
            }
        }

        response = requests.post(
            BHASHINI_URL,
            headers=headers,
            json=payload,
            timeout=30
        )

        if response.status_code == 200:

            data = response.json()

            if (
                "output" in data
                and isinstance(data["output"], list)
                and len(data["output"]) > 0
            ):
                return data["output"][0].get(
                    "target",
                    text
                )

        print(
            f"Bhashini Error: "
            f"{response.status_code} - {response.text}"
        )

        return text

    except Exception as e:

        print(
            f"Bhashini Exception: {str(e)}"
        )

        return text


def translate_to_english(
    text: str,
    source_language: str
) -> str:
    """
    Translate any supported language to English.
    """

    return translate_text(
        text=text,
        source_language=source_language,
        target_language="en"
    )


def translate_from_english(
    text: str,
    target_language: str
) -> str:
    """
    Translate English to target language.
    """

    return translate_text(
        text=text,
        source_language="en",
        target_language=target_language
    )