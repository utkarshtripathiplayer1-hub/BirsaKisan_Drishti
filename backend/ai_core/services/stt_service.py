from sarvamai import SarvamAI

from core.config import SARVAM_API_KEY

client = SarvamAI(
    api_subscription_key=SARVAM_API_KEY
)


def speech_to_text(audio_path: str):
    """
    Converts speech to text and returns both
    transcript and detected language.
    """

    try:

        response = client.speech_to_text.transcribe(
            file=open(audio_path, "rb"),
            model="saaras:v3",
            mode="transcribe"
        )

        print("STT Transcript:", response.transcript)
        print("Detected Language:", response.language_code)

        return {
            "transcript": response.transcript,
            "language": response.language_code.split("-")[0]
        }

    except Exception as e:

        print("STT Error:", e)

        return None