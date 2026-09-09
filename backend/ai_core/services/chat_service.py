from db.chat_repository import ChatRepository
from db.message_repository import MessageRepository
from services.groq_service import GroqService


class ChatService:
    """
    Conversation service for Birsa Kisan Drishti.

    Handles:

        User
          ↓
        Conversation history
          ↓
        Groq / Qwen
          ↓
        AI response
          ↓
        Save both messages
    """

    def __init__(self):
        self.groq = GroqService()

    # ========================================================
    # CREATE NEW CONVERSATION
    # ========================================================

    async def create_conversation(
        self,
        user_id: str,
        title: str = "New conversation",
    ):

        conversation = await ChatRepository.create_conversation(
            user_id=user_id,
            title=title,
        )

        return conversation

    # ========================================================
    # GET USER CONVERSATIONS
    # ========================================================

    async def get_user_conversations(
        self,
        user_id: str,
    ):

        conversations = (
            await ChatRepository.get_user_conversations(
                user_id
            )
        )

        return conversations

    # ========================================================
    # GET COMPLETE CONVERSATION
    # ========================================================

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

    # ========================================================
    # SEND MESSAGE
    # ========================================================

    async def send_message(
        self,
        conversation_id: str,
        user_id: str,
        user_text: str,
        language: str | None = None,
    ):

        if not user_text or not user_text.strip():
            raise ValueError(
                "Message cannot be empty"
            )

        # ----------------------------------------------------
        # 1. VERIFY CONVERSATION BELONGS TO USER
        # ----------------------------------------------------

        conversation = await ChatRepository.get_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        if conversation is None:
            raise ValueError(
                "Conversation not found"
            )

        # ----------------------------------------------------
        # 2. GET PREVIOUS MESSAGES
        # ----------------------------------------------------

        previous_messages = (
            await MessageRepository.get_messages(
                conversation_id=conversation_id,
                user_id=user_id,
            )
        )

        # ----------------------------------------------------
        # 3. SAVE USER MESSAGE
        # ----------------------------------------------------

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="user",
            content=user_text.strip(),
            language=language,
            message_type="text",
        )

        # ----------------------------------------------------
        # 4. BUILD CONVERSATION CONTEXT
        # ----------------------------------------------------

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

        # Add current user message
        messages_for_ai.append(
            {
                "role": "user",
                "content": user_text.strip(),
            }
        )

        # ----------------------------------------------------
        # 5. SEND CONTEXT TO QWEN
        # ----------------------------------------------------

        ai_response = await self.groq.generate_response(
            user_text=user_text.strip(),
            conversation_history=messages_for_ai,
            language=language,
        )

        if not ai_response:
            raise RuntimeError(
                "AI returned an empty response"
            )

        # ----------------------------------------------------
        # 6. SAVE AI RESPONSE
        # ----------------------------------------------------

        await MessageRepository.create_message(
            conversation_id=conversation_id,
            user_id=user_id,
            role="assistant",
            content=ai_response,
            language=language,
            message_type="text",
        )

        # ----------------------------------------------------
        # 7. UPDATE CONVERSATION
        # ----------------------------------------------------

        await ChatRepository.update_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
            update_data={
                "updated_at": __import__(
                    "datetime"
                ).datetime.utcnow()
            },
        )

        return {
            "conversation_id": conversation_id,
            "user_text": user_text.strip(),
            "ai_response": ai_response,
            "language": language,
        }

    # ========================================================
    # DELETE CONVERSATION
    # ========================================================

    async def delete_conversation(
        self,
        conversation_id: str,
        user_id: str,
    ):

        conversation = await ChatRepository.get_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        if conversation is None:
            return False

        # Delete messages first
        await MessageRepository.delete_messages(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        # Delete conversation
        deleted = await ChatRepository.delete_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        return deleted