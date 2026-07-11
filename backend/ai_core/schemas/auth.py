from pydantic import BaseModel, EmailStr


class GoogleLoginRequest(BaseModel):
    id_token: str


class UserResponse(BaseModel):
    id: str
    name: str
    email: EmailStr
    picture: str | None = None
    preferred_language: str


class GoogleLoginResponse(BaseModel):
    access_token: str
    user: UserResponse
    is_new_user: bool


class MeResponse(BaseModel):
    user: UserResponse


class UpdatePreferencesRequest(BaseModel):
    preferred_language: str

class UpdateLanguageRequest(BaseModel):
    preferred_language: str


class MessageResponse(BaseModel):
    message: str