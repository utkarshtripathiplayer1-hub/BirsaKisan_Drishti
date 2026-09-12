from datetime import datetime

from db.chat_repository import ChatRepository
from db.message_repository import MessageRepository
from services.groq_service import GroqService
from services.language_service import LanguageService


class ChatService:

    def __init__(self):

        self.groq = GroqService()
        self.language_service = LanguageService()

    # ========================================================
    # CREATE CONVERSATION
    # ========================================================

    async def create_conversation(
        self,
        user_id: str,
        title: str = "New conversation",
    ):

        return await ChatRepository.create_conversation(
            user_id=user_id,
            title=title,
        )

    # ========================================================
    # GET USER CONVERSATIONS
    # ========================================================

    async def get_user_conversations(
        self,
        user_id: str,
    ):

        return await ChatRepository.get_user_conversations(
            user_id
        )

    # ========================================================
    # GET COMPLETE CONVERSATION
    # ========================================================

    async def get_conversation(
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
            return None

        messages = (
            await MessageRepository.get_messages(
                conversation_id=conversation_id,
                user_id=user_id,
            )
        )

        return {
            "conversation": conversation,
            "messages": messages,
        }

    # ========================================================
    # SEND TEXT MESSAGE
    # ========================================================

    async def send_message(
        self,
        conversation_id: str,
        user_id: str,
        user_text: str,
    ):

        if not user_text or not user_text.strip():

            raise ValueError(
                "Message cannot be empty"
            )

        user_text = user_text.strip()

        # ----------------------------------------------------
        # VERIFY CONVERSATION
        # ----------------------------------------------------

        conversation = (
            await ChatRepository.get_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
            )
        )

        if conversation is None:

            raise ValueError(
                "Conversation not found"
            )

        # ----------------------------------------------------
        # DETECT LANGUAGE
        # ----------------------------------------------------

        detected_language = (
            self.language_service.detect_language(
                user_text
            )
        )

        # ----------------------------------------------------
        # GET HISTORY
        # ----------------------------------------------------

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

            if role not in {
                "user",
                "assistant",
            }:
                continue

            if not content:
                continue

            messages_for_ai.append(
                {
                    "role": role,
                    "content": content,
                }
            )

        # ----------------------------------------------------
        # ADD CURRENT MESSAGE
        # ----------------------------------------------------

        messages_for_ai.append(
            {
                "role": "user",
                "content": user_text,
            }
        )

        # ----------------------------------------------------
        # SAVE USER MESSAGE
        # ----------------------------------------------------

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="user",
            content=user_text,
            language=detected_language,
            message_type="text",
        )

        # ----------------------------------------------------
        # AI
        # ----------------------------------------------------

        ai_response = await self.groq.generate_response(
            user_text=user_text,
            conversation_history=messages_for_ai,
            language=detected_language,
        )

        if not ai_response:

            raise RuntimeError(
                "AI returned an empty response"
            )

        # ----------------------------------------------------
        # SAVE AI RESPONSE
        # ----------------------------------------------------

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="assistant",
            content=ai_response,
            language=detected_language,
            message_type="text",
        )

        # ----------------------------------------------------
        # UPDATE CONVERSATION
        # ----------------------------------------------------

        await ChatRepository.update_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
            update_data={
                "updated_at": datetime.utcnow()
            },
        )

        return {
            "conversation_id": conversation_id,
            "detected_language": detected_language,
            "user_text": user_text,
            "ai_response": ai_response,
        }

    # ========================================================
    # DELETE CONVERSATION
    # ========================================================

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