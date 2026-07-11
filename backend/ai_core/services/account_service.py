from db.user_repository import UserRepository
from db.crop_profile_repository import delete_crop_profile   # or CropProfileRepository
from db.conversation_repository import ConversationRepository


async def delete_account(user_id: str):

    # Delete crop profile
    await delete_crop_profile(user_id)

    # Delete conversations
    await ConversationRepository.delete_user_conversations(user_id)

    # Delete user
    await UserRepository.delete_user(user_id)

    return {
        "message": "Account deleted successfully."
    }