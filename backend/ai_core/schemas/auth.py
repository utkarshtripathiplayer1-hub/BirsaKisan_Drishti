from enum import Enum
from pydantic import BaseModel, EmailStr


class AppType(str, Enum):
    beehive = "beehive"
    agriculture = "agriculture"


class GoogleLoginRequest(BaseModel):
    id_token: str
    app_type: AppType


class UserResponse(BaseModel):
    id: str
    name: str
    email: EmailStr
    picture: str | None = None
    preferred_language: str = "English"

    new_user_beehive: bool = True
    new_user_agriculture: bool = True

    setup_completed_beehive: bool = False
    setup_completed_agriculture: bool = False


class GoogleLoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class MeResponse(BaseModel):
    user: UserResponse


class UpdatePreferencesRequest(BaseModel):
    preferred_language: str


class UpdateLanguageRequest(BaseModel):
    preferred_language: str


class MessageResponse(BaseModel):
    message: str

class SetupCompletedResponse(BaseModel):
    message: str
    setup_completed_beehive: bool | None = None
    setup_completed_agriculture: bool | None = None

class SetupCompletedRequest(BaseModel):
    app_type: AppType
