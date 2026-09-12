from datetime import datetime

from bson import ObjectId
from bson.errors import InvalidId

from db.collections import user_conversations


class ChatRepository:

    # ========================================================
    # CREATE CONVERSATION
    # ========================================================

    @staticmethod
    async def create_conversation(
        user_id: str,
        title: str = "New conversation",
    ):

        now = datetime.utcnow()

        conversation = {
            "user_id": ObjectId(user_id),
            "title": title,
            "created_at": now,
            "updated_at": now,
        }

        result = await user_conversations.insert_one(
            conversation
        )
        conversation["_id"] = str(result.inserted_id)

        return conversation

        

    # ========================================================
    # GET USER CONVERSATIONS
    # ========================================================

    @staticmethod
    async def get_user_conversations(
        user_id: str,
    ):

        try:
            user_object_id = ObjectId(user_id)

        except InvalidId:
            return []

        cursor = user_conversations.find(
            {
                "user_id": user_object_id
            }
        ).sort(
            "updated_at",
            -1,
        )

        return await cursor.to_list(
            length=None
        )

    # ========================================================
    # GET ONE CONVERSATION
    # ========================================================

    @staticmethod
    async def get_conversation(
        conversation_id: str,
        user_id: str,
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            return None

        return await user_conversations.find_one(
            {
                "_id": conversation_object_id,
                "user_id": user_object_id,
            }
        )

    # ========================================================
    # UPDATE CONVERSATION
    # ========================================================

    @staticmethod
    async def update_conversation(
        conversation_id: str,
        user_id: str,
        update_data: dict,
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            return None

        update_data["updated_at"] = datetime.utcnow()

        await user_conversations.update_one(
            {
                "_id": conversation_object_id,
                "user_id": user_object_id,
            },
            {
                "$set": update_data
            },
        )

        return await user_conversations.find_one(
            {
                "_id": conversation_object_id,
                "user_id": user_object_id,
            }
        )

    # ========================================================
    # DELETE CONVERSATION
    # ========================================================

    @staticmethod
    async def delete_conversation(
        conversation_id: str,
        user_id: str,
    ):

        try:
            conversation_object_id = ObjectId(
                conversation_id
            )

            user_object_id = ObjectId(user_id)

        except InvalidId:
            return False

        result = await user_conversations.delete_one(
            {
                "_id": conversation_object_id,
                "user_id": user_object_id,
            }
        )

        return result.deleted_count > 0