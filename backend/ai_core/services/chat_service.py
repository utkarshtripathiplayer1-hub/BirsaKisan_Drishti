import base64
from datetime import datetime

from db.chat_repository import ChatRepository
from db.message_repository import MessageRepository
from services.groq_service import GroqService
from services.bhashini_service import BhashiniService


class ChatService:

    def __init__(self):
        self.groq = GroqService()
        self.bhashini = BhashiniService()

    async def create_conversation(
        self,
        user_id: str,
        title: str = "New conversation",
    ):
        return await ChatRepository.create_conversation(
            user_id=user_id,
            title=title,
        )

    async def get_user_conversations(
        self,
        user_id: str,
    ):
        return await ChatRepository.get_user_conversations(
            user_id
        )

    async def get_conversation(
        self,
        conversation_id: str,
        user_id: str,
    ):
        conversation = await ChatRepository.get_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        if conversation is None:
            return None

        messages = await MessageRepository.get_messages(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        return {
            "conversation": conversation,
            "messages": messages,
        }

    async def send_message(
        self,
        conversation_id: str | None,
        user_id: str,
        user_text: str,
        language: str | None = None,
        generate_audio: bool = False,
    ):

        if not user_text or not user_text.strip():
            raise ValueError("Message cannot be empty")

        user_text = user_text.strip()

        # Create conversation on first message
        if not conversation_id:

            conversation = await self.create_conversation(
                user_id=user_id,
                title=user_text[:50],
            )

            conversation_id = str(
                conversation["_id"]
            )

        # Continue existing conversation
        else:

            conversation = await ChatRepository.get_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
            )

            if conversation is None:
                raise ValueError(
                    "Conversation not found"
                )

        # Get previous messages
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

            messages_for_ai.append({
                "role": role,
                "content": content,
            })

        # Add current message
        messages_for_ai.append({
            "role": "user",
            "content": user_text,
        })

        # Save user message
        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="user",
            content=user_text,
            language=language,
            message_type="text",
        )

        # Generate AI response
        ai_response = await self.groq.generate_response(
            user_text=user_text,
            conversation_history=messages_for_ai,
            language=language,
        )

        if not ai_response:
            raise RuntimeError(
                "AI returned an empty response"
            )

        ai_response = ai_response.strip()

        # Save AI response
        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="assistant",
            content=ai_response,
            language=language,
            message_type="text",
        )

        # Optional TTS
        audio_base64 = None

        if generate_audio:

            try:

                tts_language = language or "hi"

                tts_result = (
                    await self.bhashini.text_to_speech(
                        text=ai_response,
                        language=tts_language,
                        gender="female",
                        speed=1.0,
                        sampling_rate=22050,
                    )
                )

                audio_bytes = (
                    self.bhashini.extract_tts_audio(
                        tts_result
                    )
                )

                if audio_bytes:

                    audio_base64 = (
                        base64.b64encode(
                            audio_bytes
                        ).decode("utf-8")
                    )

            except Exception as e:

                print(
                    f"TTS generation failed: {e}"
                )

        # Update conversation timestamp
        await ChatRepository.update_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
            update_data={
                "updated_at": datetime.utcnow()
            },
        )

        return {
            "conversation_id": conversation_id,
            "user_text": user_text,
            "ai_response": ai_response,
            "language": language,
            "audio_base64": audio_base64,
        }

    async def rename_conversation(
        self,
        conversation_id: str,
        user_id: str,
        title: str,
    ):

        if not title or not title.strip():
            raise ValueError(
                "Conversation title cannot be empty"
            )

        conversation = (
            await ChatRepository.update_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
                update_data={
                    "title": title.strip()
                },
            )
        )

        return conversation

    async def delete_conversation(
        self,
        conversation_id: str,
        user_id: str,
    ):

        conversation = (
            await ChatRepository.get_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
            )
        )

        if conversation is None:
            return False

        await MessageRepository.delete_messages(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        return await ChatRepository.delete_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )