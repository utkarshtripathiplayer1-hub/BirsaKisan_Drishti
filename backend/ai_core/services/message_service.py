from datetime import datetime
from uuid import uuid4

from db.collections import conversation_messages

async def save_user_message(
    conversation_id: str,
    original_text: str,
    english_text: str,
    language: str):

    message_doc = {
        "message_id": f"msg_{uuid4().hex}",
        "conversation_id": conversation_id,
        "role": "user",
        "original_text": original_text,
        "english_text": english_text,
        "language": language,
        "created_at": datetime.utcnow()

    }

    await conversation_messages.insert_one(
        message_doc
    )

    return message_doc

async def save_ai_message(
    conversation_id: str,
    original_text: str,
    english_text: str,
    language: str
):
    """
    Save an AI response.
    """

    message_doc = {
        "message_id": f"msg_{uuid4().hex}",

        "conversation_id": conversation_id,

        "role": "assistant",

        "original_text": original_text,

        "english_text": english_text,

        "language": language,

        "created_at": datetime.utcnow()
    }

    await conversation_messages.insert_one(
        message_doc
    )

    return message_doc


async def get_recent_messages(
    conversation_id: str,
    limit: int = 10
):
    """
    Get recent messages for context.
    """

    cursor = (
        conversation_messages
        .find(
            {
                "conversation_id": conversation_id
            }
        )
        .sort("created_at", -1)
        .limit(limit)
    )

    messages = await cursor.to_list(
        length=limit
    )

    # Reverse so oldest comes first
    messages.reverse()

    return messages


async def get_all_messages(
    conversation_id: str
):
    """
    Get complete conversation history.
    """

    cursor = (
        conversation_messages
        .find(
            {
                "conversation_id": conversation_id
            }
        )
        .sort("created_at", 1)
    )

    messages = await cursor.to_list(
        length=None
    )

    return messages


async def delete_messages_by_conversation(
    conversation_id: str
):
    """
    Delete all messages of a conversation.
    Useful if conversation is permanently removed.
    """

    result = await conversation_messages.delete_many(
        {
            "conversation_id": conversation_id
        }
    )

    return result.deleted_count
  
