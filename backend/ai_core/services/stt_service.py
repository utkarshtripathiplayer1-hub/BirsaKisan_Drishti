from sarvamai import SarvamAI

from core.config import SARVAM_API_KEY

client = SarvamAI(
    api_subscription_key=SARVAM_API_KEY
)

def speech_to_text(audio_path: str):


    try:

        response = client.speech_to_text.transcribe(
            file=open(audio_path, "rb"),
            model="saaras:v3",
            mode="transcribe"
        )
    

        return response.transcript

    except Exception as e:

        print("STT Error:", e)

        return None