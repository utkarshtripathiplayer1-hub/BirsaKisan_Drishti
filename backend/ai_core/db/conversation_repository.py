from db.collections import user_conversations


class ConversationRepository:

    @staticmethod
    async def get_user_conversations(user_id: str):
        cursor = (
            user_conversations
            .find({"user_id": user_id})
            .sort("updated_at", -1)
        )
        return await cursor.to_list(length=None)

    @staticmethod
    async def get_by_conversation_id(conversation_id: str):
        return await user_conversations.find_one(
            {"conversation_id": conversation_id}
        )

    @staticmethod
    async def delete_user_conversations(user_id: str):
        await user_conversations.delete_many(
            {"user_id": user_id}
        )