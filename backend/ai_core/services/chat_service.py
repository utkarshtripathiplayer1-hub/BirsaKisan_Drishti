from services.conversation_service import (
    create_conversation,
    update_conversation_timestamp
)

from services.message_service import (
    save_user_message,
    save_ai_message,
    get_recent_messages
)

from services.groq_service import ask_groq
from services.context_service import get_user_context
from services.sarvam_service import translate_text

async def process_chat(
    user_id: str,
    domain: str,
    language: str,
    query: str,
    conversation_id: str | None = None
):
    """
    Main chat orchestration service.
    """

    # Create conversation if this is a new chat
    if conversation_id is None:

        conversation = await create_conversation(
            user_id=user_id,
            domain=domain,
            language=language,
            first_message=query
        )

        conversation_id = conversation["conversation_id"]
    # Keep original user message
    original_query = query

    # Translate to English for AI processing
    if language != "en":


        query = translate_text(
            text=query,
            source_language=language,
            target_language="en"
        )
    # Save user message
        await save_user_message(
            conversation_id=conversation_id,
            original_text=original_query,
            english_text=query,
            language=language
        )

    # Update conversation timestamp
    await update_conversation_timestamp(
        conversation_id
    )

    # Get recent messages for context
    history = await get_recent_messages(
        conversation_id=conversation_id,
        limit=10
    )

    # Get crop backend context
    try:
        context = get_user_context(user_id)
    except Exception as e:
        print("Context Fetch Error:", e)
        context = None

    groq_messages = []

    # Add farming context
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
                "content": farming_context
            }
        )

    # Add conversation history
    for msg in history:

        groq_messages.append(
            {
                "role": msg["role"],
                "content": msg["english_text"]
            }
        )

    # Generate AI response
    ai_response = ask_groq(
        groq_messages
    )


    final_response = ai_response

    if language != "en":


        final_response = translate_text(
            text=ai_response,
            source_language="en",
            target_language=language
        )

    # Save AI response
    await save_ai_message(
        conversation_id=conversation_id,
        original_text=final_response,
        english_text=ai_response,
        language=language
    )

    return {
        "conversation_id": conversation_id,
        "response": final_response
    }

