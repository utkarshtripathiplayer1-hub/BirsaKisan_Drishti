from datetime import datetime
from typing import Optional
from enum import Enum 
from pydantic import BaseModel

class Role(str, Enum):
    FARMER = "Farmer"


class Gender(str, Enum):
    MALE = "Male"
    FEMALE = "Female"
    OTHER = "Other"


class IrrigationMethod(str, Enum):
    DRIP = "Drip"
    SPRINKLER = "Sprinkler"
    FLOOD = "Flood"
    RAINFED = "Rainfed"


class SoilType(str, Enum):
    RED = "Red Soil"
    BLACK = "Black Soil"
    CLAYEY = "Clayey"
    LOAMY = "Loamy"
    SANDY = "Sandy"


class Education(str, Enum):
    NONE = "No Formal Education"
    PRIMARY = "Primary"
    SECONDARY = "Secondary"
    HIGHER_SECONDARY = "Higher Secondary"
    DIPLOMA = "Diploma"
    GRADUATE = "Graduate"
    POST_GRADUATE = "Post Graduate"

class BasicInfo(BaseModel):
    role: Optional[Role] = None
    age: Optional[int] = None
    gender: Optional[Gender] = None
    education: Optional[Education] = None
    phone: Optional[str] = None

# Location Information
class LocationInfo(BaseModel):
    country: Optional[str] = None
    state: Optional[str] = None
    district: Optional[str] = None
    village: Optional[str] = None

    latitude: Optional[float] = None
    longitude: Optional[float] = None



class FarmInfo(BaseModel):
    farm_name: Optional[str] = None

    farm_size: Optional[float] = None
    soil_type: Optional[str] = None
    irrigation_method: Optional[str] = None


# -----------------------------
# Create Profile
# -----------------------------
class CreateCropProfileRequest(BaseModel):
    basic_info: BasicInfo
    location: LocationInfo
    farm_info: FarmInfo


# -----------------------------
# Update Profile
# -----------------------------
class UpdateCropProfileRequest(BaseModel):
    basic_info: Optional[BasicInfo] = None
    location: Optional[LocationInfo] = None
    farm_info: Optional[FarmInfo] = None


# -----------------------------
# Response
# -----------------------------
class CropProfileResponse(BaseModel):
    user_id: str
    basic_info: BasicInfo
    location: LocationInfo
    farm_info: FarmInfo

    created_at: datetime
    updated_at: datetime


