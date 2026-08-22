from fastapi import HTTPException

from core.prompts import AGRICULTURE_SYSTEM_PROMPT

from services.conversation_service import (
    create_conversation,
    update_conversation_timestamp,
)

from services.message_service import (
    save_user_message,
    save_ai_message,
    get_recent_messages,
)

from services.groq_service import ask_groq
from services.context_service import get_user_context
from services.sarvam_service import translate_text

from db.conversation_repository import ConversationRepository

from schemas.chat import (
    ConversationResponse,
    ConversationListResponse,
)


async def process_chat(
    user_id: str,
    access_token: str,
    domain: str,
    language: str,
    query: str,
    conversation_id: str | None = None,
):
    """
    Main chat orchestration service.
    """

    # --------------------------------------------------
    # Validate existing conversation
    # --------------------------------------------------
    if conversation_id:

        conversation = await ConversationRepository.get_by_conversation_id(
            conversation_id
        )

        if conversation is None:
            raise HTTPException(
                status_code=404,
                detail="Conversation not found",
            )

        if conversation["user_id"] != user_id:
            raise HTTPException(
                status_code=403,
                detail="You are not allowed to access this conversation",
            )

    else:

        conversation = await create_conversation(
            user_id=user_id,
            domain=domain,
            language=language,
            first_message=query,
        )

        conversation_id = conversation["conversation_id"]

    # --------------------------------------------------
    # Translate user query to English
    # --------------------------------------------------
    original_query = query

    if language != "en":

        query = translate_text(
            text=query,
            source_language=language,
            target_language="en",
        )

    # --------------------------------------------------
    # Save user message
    # --------------------------------------------------
    await save_user_message(
        conversation_id=conversation_id,
        original_text=original_query,
        english_text=query,
        language=language,
    )

    # --------------------------------------------------
    # Update conversation timestamp
    # --------------------------------------------------
    await update_conversation_timestamp(
        conversation_id
    )

    # --------------------------------------------------
    # Load recent conversation history
    # --------------------------------------------------
    history = await get_recent_messages(
        conversation_id=conversation_id,
        limit=10,
    )

    # --------------------------------------------------
    # Fetch farming context
    # --------------------------------------------------
    try:

        context = get_user_context(
            user_id=user_id,
            access_token=access_token,
        )

        print("========== USER CONTEXT ==========")
        print(context)
        print("==================================")

    except Exception as e:

        print("Context Fetch Error:", e)
        context = None

    # --------------------------------------------------
    # Build prompt for AI
    # --------------------------------------------------
    groq_messages = [
        {
            "role": "system",
            "content": f"""
{AGRICULTURE_SYSTEM_PROMPT}

IMPORTANT:

- Always answer in {language}.
- Current domain is {domain}.
- Continue the conversation naturally.
- Use previous conversation when relevant.
- Keep answers practical and farmer-friendly.
""",
        }
    ]

    # --------------------------------------------------
    # Add farming context
    # --------------------------------------------------
    if context:

        farming_context = f"""
Latest Farming Context

Last Disease Detection:
{context.get('last_detection')}

Last Crop Recommendation:
{context.get('last_recommendation')}
"""

        groq_messages.append(
            {
                "role": "system",
                "content": farming_context,
            }
        )

    # --------------------------------------------------
    # Add previous messages
    # --------------------------------------------------
    for msg in history:

        groq_messages.append(
            {
                "role": msg["role"],
                "content": msg["english_text"],
            }
        )

    # --------------------------------------------------
    # Current user query
    # --------------------------------------------------
    groq_messages.append(
        {
            "role": "user",
            "content": query,
        }
    )

    # --------------------------------------------------
    # Generate AI response
    # --------------------------------------------------
    ai_response = await ask_groq(
        groq_messages
    )

    # --------------------------------------------------
    # Translate response back
    # --------------------------------------------------
    final_response = ai_response

    if language != "en":

        final_response = translate_text(
            text=ai_response,
            source_language="en",
            target_language=language,
        )

    # --------------------------------------------------
    # Save AI response
    # --------------------------------------------------
    await save_ai_message(
        conversation_id=conversation_id,
        original_text=final_response,
        english_text=ai_response,
        language=language,
    )

    return {
        "conversation_id": conversation_id,
        "response": final_response,
    }


async def get_conversations(user_id: str):

    conversations = await ConversationRepository.get_user_conversations(
        user_id
    )

    return ConversationListResponse(
        conversations=[
            ConversationResponse(
                conversation_id=conv["conversation_id"],
                title=conv["title"],
                domain=conv["domain"],
                updated_at=conv["updated_at"],
            )
            for conv in conversations
        ]
    )