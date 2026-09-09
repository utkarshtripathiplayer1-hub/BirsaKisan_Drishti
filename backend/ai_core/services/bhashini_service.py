import base64
import httpx

from core.config import (
    BHASHINI_INFERENCE_KEY,
    BHASHINI_INFERENCE_URL,
    BHASHINI_ASR_SERVICE_ID,
    BHASHINI_TTS_SERVICE_ID,
)


class BhashiniService:
    """
    Bhashini voice service.

    Handles:

        ASR
        Speech → Text

        TTS
        Text → Speech
    """

    # ========================================================
    # SUPPORTED LANGUAGES
    # ========================================================

    SUPPORTED_LANGUAGES = {
        "hi": "Hindi",
        "en": "English",
    }

    # ========================================================
    # INITIALIZATION
    # ========================================================

    def __init__(self):

        self.inference_url = BHASHINI_INFERENCE_URL
        self.inference_key = BHASHINI_INFERENCE_KEY

        self.asr_service_id = BHASHINI_ASR_SERVICE_ID
        self.tts_service_id = BHASHINI_TTS_SERVICE_ID

    # ========================================================
    # LANGUAGE
    # ========================================================

    @classmethod
    def normalize_language(
        cls,
        language: str,
    ) -> str:
        """
        Normalize and validate language code.

        Example:

            Hindi
            hi
            HI

        becomes:

            hi
        """

        if not language:
            raise ValueError(
                "Language cannot be empty"
            )

        language = language.lower().strip()

        if language not in cls.SUPPORTED_LANGUAGES:
            raise ValueError(
                f"Unsupported Bhashini language: {language}. "
                f"Supported languages: "
                f"{', '.join(cls.SUPPORTED_LANGUAGES.keys())}"
            )

        return language

    # ========================================================
    # HEADERS
    # ========================================================

    def _headers(self) -> dict[str, str]:

        return {
            "Authorization": self.inference_key,
            "Content-Type": "application/json",
        }

    # ========================================================
    # ASR
    # ========================================================

    async def speech_to_text(
        self,
        audio_base64: str,
        language: str = "hi",
    ) -> dict:
        """
        Speech → Text using Bhashini ASR.

        Audio requirements:

            WAV
            16 kHz
            Base64 encoded
        """

        if not audio_base64:
            raise ValueError(
                "Audio content cannot be empty"
            )

        language = self.normalize_language(
            language
        )

        payload = {
            "pipelineTasks": [
                {
                    "taskType": "asr",
                    "config": {
                        "language": {
                            "sourceLanguage": language
                        },
                        "serviceId": self.asr_service_id,
                        "audioFormat": "wav",
                        "samplingRate": 16000,
                        "preProcessors": [
                            "vad"
                        ],
                        "postProcessors": [
                            "itn"
                        ],
                    },
                }
            ],
            "inputData": {
                "audio": [
                    {
                        "audioContent": audio_base64
                    }
                ]
            },
        }

        async with httpx.AsyncClient(
            timeout=60.0
        ) as client:

            response = await client.post(
                self.inference_url,
                json=payload,
                headers=self._headers(),
            )

        if response.status_code != 200:

            raise RuntimeError(
                "Bhashini ASR failed "
                f"({response.status_code}): "
                f"{response.text}"
            )

        return response.json()

    # ========================================================
    # EXTRACT ASR TEXT
    # ========================================================

    @staticmethod
    def extract_asr_text(
        result: dict,
    ) -> str:
        """
        Extract recognized text from Bhashini ASR response.
        """

        pipeline_response = result.get(
            "pipelineResponse",
            []
        )

        for task in pipeline_response:

            if task.get("taskType") != "asr":
                continue

            output = task.get(
                "output",
                []
            )

            if not output:
                return ""

            return output[0].get(
                "source",
                ""
            )

        return ""

    # ========================================================
    # TTS
    # ========================================================

    async def text_to_speech(
        self,
        text: str,
        language: str = "hi",
        gender: str = "female",
        speed: float = 1.0,
        sampling_rate: int = 22050,
    ) -> dict:
        """
        Text → Speech using Bhashini TTS.
        """

        # ----------------------------------------------------
        # Validate text
        # ----------------------------------------------------

        if not text or not text.strip():

            raise ValueError(
                "TTS text cannot be empty"
            )

        # ----------------------------------------------------
        # Normalize language
        # ----------------------------------------------------

        language = self.normalize_language(
            language
        )

        # ----------------------------------------------------
        # Validate gender
        # ----------------------------------------------------

        gender = gender.lower().strip()

        if gender not in {
            "male",
            "female",
        }:

            raise ValueError(
                "gender must be 'male' or 'female'"
            )

        # ----------------------------------------------------
        # Validate speed
        # ----------------------------------------------------

        if not 0.1 <= speed <= 1.99:

            raise ValueError(
                "speed must be between 0.1 and 1.99"
            )

        # ----------------------------------------------------
        # Validate sampling rate
        # ----------------------------------------------------

        if sampling_rate <= 0:

            raise ValueError(
                "sampling_rate must be greater than 0"
            )

        # ====================================================
        # BHASHINI PAYLOAD
        # ====================================================

        payload = {
            "pipelineTasks": [
                {
                    "taskType": "tts",
                    "config": {
                        "language": {
                            "sourceLanguage": language
                        },
                        "serviceId": self.tts_service_id,
                        "gender": gender,
                        "speed": speed,
                        "samplingRate": sampling_rate,
                    },
                }
            ],
            "inputData": {
                "input": [
                    {
                        "source": text
                    }
                ],
                "audio": [
                    {
                        "audioContent": None
                    }
                ],
            },
        }

        # ====================================================
        # REQUEST
        # ====================================================

        async with httpx.AsyncClient(
            timeout=60.0
        ) as client:

            response = await client.post(
                self.inference_url,
                json=payload,
                headers=self._headers(),
            )

        if response.status_code != 200:

            raise RuntimeError(
                "Bhashini TTS failed "
                f"({response.status_code}): "
                f"{response.text}"
            )

        return response.json()

    # ========================================================
    # EXTRACT TTS AUDIO
    # ========================================================

    @staticmethod
    def extract_tts_audio(
        result: dict,
    ) -> bytes:
        """
        Extract Base64 audio from Bhashini TTS response
        and convert it to bytes.
        """

        pipeline_response = result.get(
            "pipelineResponse",
            []
        )

        for task in pipeline_response:

            if task.get("taskType") != "tts":
                continue

            audio = task.get(
                "audio",
                []
            )

            if not audio:

                raise RuntimeError(
                    "Bhashini TTS returned no audio"
                )

            audio_content = audio[0].get(
                "audioContent"
            )

            if not audio_content:

                raise RuntimeError(
                    "Bhashini TTS returned empty audio"
                )

            try:

                return base64.b64decode(
                    audio_content
                )

            except Exception as e:

                raise RuntimeError(
                    f"Failed to decode Bhashini audio: {e}"
                )

        raise RuntimeError(
            "TTS response did not contain a TTS task"
        )