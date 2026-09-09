from datetime import datetime

from bson import ObjectId
from bson.errors import InvalidId

from db.collections import conversation_messages


class MessageRepository:

    # ========================================================
    # CREATE MESSAGE
    # ========================================================

    @staticmethod
    async def create_message(
        conversation_id: str,
        user_id: str,
        role: str,
        content: str,
        language: str | None = None,
        message_type: str = "text",
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            raise ValueError(
                "Invalid conversation or user ID"
            )

        message = {
            "conversation_id": conversation_object_id,
            "user_id": user_object_id,
            "role": role,
            "content": content,
            "language": language,
            "message_type": message_type,
            "created_at": datetime.utcnow(),
        }

        result = await conversation_messages.insert_one(
            message
        )

        return await conversation_messages.find_one(
            {"_id": result.inserted_id}
        )

    # ========================================================
    # GET CONVERSATION MESSAGES
    # ========================================================

    @staticmethod
    async def get_messages(
        conversation_id: str,
        user_id: str,
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            return []

        cursor = conversation_messages.find(
            {
                "conversation_id": conversation_object_id,
                "user_id": user_object_id,
            }
        ).sort(
            "created_at",
            1,
        )

        return await cursor.to_list(
            length=None
        )

    # ========================================================
    # DELETE CONVERSATION MESSAGES
    # ========================================================

    @staticmethod
    async def delete_messages(
        conversation_id: str,
        user_id: str,
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            return 0

        result = await conversation_messages.delete_many(
            {
                "conversation_id": conversation_object_id,
                "user_id": user_object_id,
            }
        )

        return result.deleted_count