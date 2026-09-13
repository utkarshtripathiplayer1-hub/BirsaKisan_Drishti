import base64

from services.bhashini_service import BhashiniService
from services.groq_service import GroqService
from services.language_service import LanguageService

from db.chat_repository import ChatRepository
from db.message_repository import MessageRepository


class VoiceService:

    def __init__(self):
        self.bhashini = BhashiniService()
        self.groq = GroqService()
        self.language_service = LanguageService()

    async def process_voice(
        self,
        audio_base64: str,
        conversation_id: str | None,
        user_id: str,
    ):

        if not audio_base64:
            raise ValueError("Audio content cannot be empty")

        # ====================================================
        # 1. CREATE OR VERIFY CONVERSATION
        # ====================================================

        if not conversation_id:

            conversation = await ChatRepository.create_conversation(
                user_id=user_id,
                title="Voice conversation",
            )

            conversation_id = str(
                conversation["_id"]
            )

        else:

            conversation = await ChatRepository.get_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
            )

            if conversation is None:
                raise ValueError(
                    "Conversation not found"
                )

        # ====================================================
        # 2. ASR - HINDI
        # ====================================================

        hi_text = ""

        try:
            hi_result = await self.bhashini.speech_to_text(
                audio_base64=audio_base64,
                language="hi",
            )

            hi_text = (
                self.bhashini.extract_asr_text(
                    hi_result
                )
                .strip()
            )

        except Exception as e:
            print(f"Hindi ASR failed: {e}")

        # ====================================================
        # 3. ASR - ENGLISH
        # ====================================================

        en_text = ""

        try:
            en_result = await self.bhashini.speech_to_text(
                audio_base64=audio_base64,
                language="en",
            )

            en_text = (
                self.bhashini.extract_asr_text(
                    en_result
                )
                .strip()
            )

        except Exception as e:
            print(f"English ASR failed: {e}")

        # ====================================================
        # 4. VALIDATE ASR
        # ====================================================

        if not hi_text and not en_text:
            raise RuntimeError(
                "Bhashini could not recognize the audio"
            )

        # ====================================================
        # 5. DETECT LANGUAGE
        # ====================================================

        hi_detected = None
        en_detected = None

        if hi_text:
            hi_detected = (
                self.language_service.detect_language(
                    hi_text
                )
            )

        if en_text:
            en_detected = (
                self.language_service.detect_language(
                    en_text
                )
            )

        # ====================================================
        # 6. SELECT BEST TEXT
        # ====================================================

        if hi_text and hi_detected == "hi":

            user_text = hi_text
            detected_language = "hi"

        elif en_text and en_detected == "en":

            user_text = en_text
            detected_language = "en"

        elif hi_text:

            user_text = hi_text
            detected_language = hi_detected or "hi"

        else:

            user_text = en_text
            detected_language = en_detected or "en"

        # ====================================================
        # 7. GET HISTORY
        # ====================================================

        previous_messages = (
            await MessageRepository.get_messages(
                conversation_id=conversation_id,
                user_id=user_id,
            )
        )

        messages_for_ai = []

        for message in previous_messages:

            role = message.get("role")
            content = message.get("content")

            if role not in {"user", "assistant"}:
                continue

            if not content:
                continue

            messages_for_ai.append(
                {
                    "role": role,
                    "content": content,
                }
            )

        messages_for_ai.append(
            {
                "role": "user",
                "content": user_text,
            }
        )

        # ====================================================
        # 8. SAVE USER VOICE MESSAGE
        # ====================================================

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="user",
            content=user_text,
            language=detected_language,
            message_type="voice",
        )

        # ====================================================
        # 9. GROQ
        # ====================================================

        ai_response = await self.groq.generate_response(
            user_text=user_text,
            conversation_history=messages_for_ai,
            language=detected_language,
        )

        if not ai_response:
            raise RuntimeError(
                "Groq returned an empty response"
            )

        ai_response = ai_response.strip()

        # ====================================================
        # 10. SAVE AI RESPONSE
        # ====================================================

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="assistant",
            content=ai_response,
            language=detected_language,
            message_type="text",
        )

        # ====================================================
        # 11. TTS
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
        # 12. BASE64 AUDIO
        # ====================================================

        audio_base64_response = base64.b64encode(
            audio_bytes
        ).decode("utf-8")

        # ====================================================
        # 13. UPDATE CONVERSATION
        # ====================================================

        await ChatRepository.update_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
            update_data={},
        )

        # ====================================================
        # 14. RESPONSE
        # ====================================================

        return {
            "conversation_id": conversation_id,
            "detected_language": detected_language,
            "user_text": user_text,
            "ai_response": ai_response,
            "audio_base64": audio_base64_response,
        }