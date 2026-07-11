import base64

from sarvamai import SarvamAI

from core.config import SARVAM_API_KEY
from services.sarvam_service import LANGUAGE_MAP

client = SarvamAI(
    api_subscription_key=SARVAM_API_KEY
)


def text_to_speech(
    text: str,
    language: str,
    output_file: str,
):
    """
    Convert text into speech using Sarvam AI.
    """

    response = client.text_to_speech.convert(
        text=text,
        target_language_code=LANGUAGE_MAP.get(language, "en-IN")
    )

    audio_base64 = response.audios[0]

    audio_bytes = base64.b64decode(audio_base64)

    with open(output_file, "wb") as f:
        f.write(audio_bytes)

    return output_file