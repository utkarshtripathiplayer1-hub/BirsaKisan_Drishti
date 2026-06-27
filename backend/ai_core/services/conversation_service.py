from datetime import datetime
from uuid import uuid4

from db.collections import user_conversations

from services.title_service import generate_title

async def create_conversation(
    user_id: str,
    domain: str,
    language: str,
    first_message: str):

    conversation_id = f"conv_{uuid4().hex}"

    title = generate_title(first_message)

    conversation_doc = {
        "conversation_id": conversation_id,
        "user_id": user_id,
        "domain": domain,
        "title": title,
        "language": language,
        "summary": "",
        "is_deleted": False,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()

    }

    await user_conversations.insert_one(
        conversation_doc
    )

    return conversation_doc


async def get_user_conversations(
    user_id: str,
    domain: str
):

    cursor = (
        user_conversations
        .find(
            {
                "user_id": user_id,
                "domain": domain,
                "is_deleted": False
            }
        )
        .sort("updated_at", -1)
    )

    conversations = await cursor.to_list(
        length=None
    )

    return conversations

async def get_conversation_by_id(
    conversation_id: str
):

    conversation = await user_conversations.find_one(
        {
            "conversation_id": conversation_id,
            "is_deleted": False
        }
    )

    return conversation


async def update_conversation_timestamp(
    conversation_id: str
):
    await user_conversations.update_one(
        {
            "conversation_id": conversation_id
        },
        {
            "$set": {
                "updated_at": datetime.utcnow()
            }
        }
    )


async def rename_conversation(
    conversation_id: str,
    title: str
):
    result = await user_conversations.update_one(
        {
            "conversation_id": conversation_id,
            "is_deleted": False
        },
        {
            "$set": {
                "title": title
            }
        }
    )

    return result.modified_count


async def delete_conversation(
    conversation_id: str
):
    result = await user_conversations.update_one(
        {
            "conversation_id": conversation_id
        },
        {
            "$set": {
                "is_deleted": True
            }
        }
    )

    return result.modified_count