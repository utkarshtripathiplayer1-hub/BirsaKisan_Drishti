
from bson.errors import InvalidId
from fastapi import Depends, HTTPException, status
from fastapi.security import (
    HTTPAuthorizationCredentials,
    HTTPBearer,
)

from core.jwt import verify_access_token
from db.user_repository import UserRepository


security = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    # Check whether the Authorization header exists
    if credentials is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization token missing",
        )

    token = credentials.credentials

    # Verify JWT signature, expiration and claims
    payload = verify_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )

    # Retrieve user from MongoDB
    try:
        user = await UserRepository.get_by_id(payload["sub"])
    except (InvalidId, KeyError, TypeError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
        )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User no longer exists",
        )

    # Preserve the JWT for authenticated requests
    # forwarded to other backends, if required.
    user["_access_token"] = token

    return user
