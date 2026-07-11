from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from core.jwt import verify_access_token
from db.user_repository import UserRepository
from bson.errors import InvalidId
security = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    print("Credentials:", credentials)
    if credentials is None:
        raise HTTPException(
            status_code=401,
            detail="Authorization token missing"
        )

    token = credentials.credentials

    payload = verify_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token"
        )

    try:
        user = await UserRepository.get_by_id(payload["sub"])
    except InvalidId:
        raise HTTPException(
            status_code=401,
            detail="Invalid token"
        )

    if user is None:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user