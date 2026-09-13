import base64
import subprocess
import tempfile
import os
import httpx

from core.config import (
    BHASHINI_INFERENCE_KEY,
    BHASHINI_INFERENCE_URL,
    BHASHINI_ASR_SERVICE_ID,
    BHASHINI_TTS_SERVICE_ID,
)


class BhashiniService:

    SUPPORTED_LANGUAGES = {
        "hi": "Hindi",
        "en": "English",
    }

    def __init__(self):
        self.inference_url = BHASHINI_INFERENCE_URL
        self.inference_key = BHASHINI_INFERENCE_KEY
        self.asr_service_id = BHASHINI_ASR_SERVICE_ID
        self.tts_service_id = BHASHINI_TTS_SERVICE_ID

    @classmethod
    def normalize_language(cls, language: str) -> str:

        if not language:
            raise ValueError("Language cannot be empty")

        language = language.lower().strip()

        if language not in cls.SUPPORTED_LANGUAGES:
            raise ValueError(
                f"Unsupported Bhashini language: {language}"
            )

        return language

    def _headers(self) -> dict[str, str]:

        return {
            "Authorization": self.inference_key,
            "Content-Type": "application/json",
        }

    # ========================================================
    # AUDIO CONVERSION
    # ========================================================

    @staticmethod
    def convert_to_wav(audio_bytes: bytes) -> bytes:
        """
        Convert uploaded audio to:

        WAV
        PCM signed 16-bit
        Mono
        16 kHz

        This makes Flutter audio compatible with
        Bhashini ASR.
        """

        if not audio_bytes:
            raise ValueError("Audio content cannot be empty")

        input_file = None
        output_file = None

        try:

            with tempfile.NamedTemporaryFile(
                suffix=".input",
                delete=False,
            ) as input_temp:

                input_temp.write(audio_bytes)
                input_file = input_temp.name

            with tempfile.NamedTemporaryFile(
                suffix=".wav",
                delete=False,
            ) as output_temp:

                output_file = output_temp.name

            command = [
                "ffmpeg",
                "-y",
                "-i",
                input_file,
                "-ac",
                "1",
                "-ar",
                "16000",
                "-sample_fmt",
                "s16",
                output_file,
            ]

            result = subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )

            if result.returncode != 0:

                error = result.stderr.decode(
                    "utf-8",
                    errors="ignore",
                )

                raise RuntimeError(
                    f"FFmpeg audio conversion failed: {error}"
                )

            with open(output_file, "rb") as file:
                wav_bytes = file.read()

            if not wav_bytes:
                raise RuntimeError(
                    "FFmpeg produced empty WAV audio"
                )

            return wav_bytes

        finally:

            if input_file and os.path.exists(input_file):
                os.remove(input_file)

            if output_file and os.path.exists(output_file):
                os.remove(output_file)

    # ========================================================
    # ASR
    # ========================================================

    async def speech_to_text(
        self,
        audio_base64: str,
        language: str = "hi",
    ) -> dict:

        if not audio_base64:
            raise ValueError(
                "Audio content cannot be empty"
            )

        language = self.normalize_language(language)

        try:
            original_audio = base64.b64decode(
                audio_base64
            )
        except Exception as e:
            raise ValueError(
                f"Invalid Base64 audio: {e}"
            )

        # Convert any uploaded audio to WAV 16kHz mono
        wav_audio = self.convert_to_wav(
            original_audio
        )

        wav_base64 = base64.b64encode(
            wav_audio
        ).decode("utf-8")

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
                        "audioContent": wav_base64
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
    def extract_asr_text(result: dict) -> str:

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

        if not text or not text.strip():
            raise ValueError(
                "TTS text cannot be empty"
            )

        language = self.normalize_language(
            language
        )

        gender = gender.lower().strip()

        if gender not in {"male", "female"}:
            raise ValueError(
                "gender must be 'male' or 'female'"
            )

        if not 0.1 <= speed <= 1.99:
            raise ValueError(
                "speed must be between 0.1 and 1.99"
            )

        if sampling_rate <= 0:
            raise ValueError(
                "sampling_rate must be greater than 0"
            )

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