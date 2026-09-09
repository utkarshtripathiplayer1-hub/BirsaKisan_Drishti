from services.bhashini_service import BhashiniService
from services.groq_service import GroqService
from services.language_service import LanguageService


class VoiceService:
    """
    Complete Birsa Kisan Drishti voice pipeline.

    Farmer voice
        ↓
    Bhashini ASR
        ↓
    Recognized text
        ↓
    Language Detection
        ↓
    Qwen via Groq
        ↓
    AI response text
        ↓
    Bhashini TTS
        ↓
    Audio bytes

    The response language is automatically determined
    from the recognized farmer text.
    """

    # ========================================================
    # INITIALIZATION
    # ========================================================

    def __init__(self):

        self.bhashini = BhashiniService()

        self.groq = GroqService()

        self.language_service = LanguageService()

    # ========================================================
    # VOICE → VOICE
    # ========================================================

    async def process_voice(
        self,
        audio_base64: str,
        language: str = "hi",
    ) -> dict:
        """
        Process farmer voice through the complete pipeline.

        Flow:

            Audio
              ↓
            ASR
              ↓
            Text
              ↓
            Language Detection
              ↓
            Groq / Qwen
              ↓
            AI Text
              ↓
            TTS
              ↓
            Audio

        `language` is currently used only for ASR because
        Bhashini ASR needs a source language before
        transcription.

        Once ASR produces text, the actual response language
        is detected automatically.
        """

        # ====================================================
        # VALIDATE AUDIO
        # ====================================================

        if not audio_base64:
            raise ValueError(
                "Audio content cannot be empty"
            )

        # ====================================================
        # 1. ASR — VOICE → TEXT
        # ====================================================

        asr_result = await self.bhashini.speech_to_text(
            audio_base64=audio_base64,
            language=language,
        )

        user_text = self.bhashini.extract_asr_text(
            asr_result
        )

        if not user_text:
            raise RuntimeError(
                "Bhashini could not recognize the audio"
            )

        # ====================================================
        # 2. DETECT LANGUAGE FROM RECOGNIZED TEXT
        # ====================================================

        detected_language = (
            self.language_service.detect_language(
                user_text
            )
        )

        # ====================================================
        # 3. QWEN / GROQ — TEXT → AI RESPONSE
        # ====================================================

        ai_response = await self.groq.generate_response(
            user_text=user_text,
            response_language=detected_language,
        )

        if not ai_response:
            raise RuntimeError(
                "Qwen returned an empty response"
            )

        # ====================================================
        # 4. TTS — AI RESPONSE → VOICE
        # ====================================================

        tts_result = await self.bhashini.text_to_speech(
            text=ai_response,
            language=detected_language,
            gender="female",
            speed=1.0,
            sampling_rate=22050,
        )

        audio_bytes = (
            self.bhashini.extract_tts_audio(
                tts_result
            )
        )

        if not audio_bytes:
            raise RuntimeError(
                "Bhashini returned empty audio"
            )

        # ====================================================
        # 5. RETURN PIPELINE RESULT
        # ====================================================

        return {
            "recognized_text": user_text,
            "detected_language": detected_language,
            "ai_response": ai_response,
            "audio": audio_bytes,
        }