from fastapi import APIRouter, HTTPException, Depends

from app.auth.dependencies import get_current_user
from app.services.ai_context_Service import get_user_context
from app.schemas.ai_context_schema import AIContextResponse

router = APIRouter()


@router.get(
    "/user-context",
    response_model=AIContextResponse
)
async def fetch_user_context(
    current_user=Depends(get_current_user)
):
    """
    Returns the latest crop recommendation and disease detection
    for the authenticated user.
    """

    user_id = current_user["sub"]

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
