from fastapi import APIRouter, HTTPException

from app.services.ai_context_Service import get_user_context
from app.schemas.ai_context_schema import AIContextResponse

router = APIRouter()


@router.get(
    "/user-context/{user_id}",
    response_model=AIContextResponse
)
async def fetch_user_context(user_id: str):
    """
    Returns latest crop recommendation and disease detection
    for a user.
    """

    context = await get_user_context(user_id)

    if (
        context["last_detection"] is None
        and context["last_recommendation"] is None
    ):
        raise HTTPException(
            status_code=404,
            detail="No context found for user"
        )

    return AIContextResponse(
        user_id=context["user_id"],
        last_detection=context["last_detection"],
        last_recommendation=context["last_recommendation"]
    )
