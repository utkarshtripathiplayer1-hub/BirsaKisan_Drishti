from fastapi import HTTPException, Depends
from fastapi.security import HTTPAuthorizationCredentials

from app.auth.jwt_auth import verify_access_token
from app.auth.security import security


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):

    token = credentials.credentials

    print("JWT TOKEN:", token)

    payload = verify_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token"
        )

    payload["token"] = token

    return payload