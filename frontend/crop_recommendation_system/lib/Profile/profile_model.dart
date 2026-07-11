class CropProfile {
  final BasicInfo basicInfo;
  final LocationInfo location;
  final FarmInfo farmInfo;
  final UserInfo user;

  CropProfile({
    required this.user,
    required this.basicInfo,
    required this.location,
    required this.farmInfo,
  });

  factory CropProfile.fromJson(Map<String, dynamic> json) {
    return CropProfile(
      user: UserInfo.fromJson(json["user"]),
      basicInfo: BasicInfo.fromJson(json["basic_info"]),
      location: LocationInfo.fromJson(json["location"]),
      farmInfo: FarmInfo.fromJson(json["farm_info"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "basic_info": basicInfo.toJson(),
      "location": location.toJson(),
      "farm_info": farmInfo.toJson(),
    };
  }
}

class BasicInfo {
  final String role;
  final int age;
  final String gender;
  final String education;
  final String phone;

  BasicInfo({
    required this.role,
    required this.age,
    required this.gender,
    required this.education,
    required this.phone,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      role: json["role"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      education: json["education"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "age": age,
      "gender": gender,
      "education": education,
      "phone": phone,
    };
  }
}

class LocationInfo {
  final String country;
  final String state;
  final String district;
  final String village;
  final double latitude;
  final double longitude;

  LocationInfo({
    required this.country,
    required this.state,
    required this.district,
    required this.village,
    required this.latitude,
    required this.longitude,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      country: json["country"] ?? "",
      state: json["state"] ?? "",
      district: json["district"] ?? "",
      village: json["village"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "state": state,
      "district": district,
      "village": village,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

class FarmInfo {
  final String farmName;
  final double farmSize;
  final String soilType;
  final String irrigationMethod;

  FarmInfo({
    required this.farmName,
    required this.farmSize,
    required this.soilType,
    required this.irrigationMethod,
  });

  factory FarmInfo.fromJson(Map<String, dynamic> json) {
    return FarmInfo(
      farmName: json["farm_name"] ?? "",
      farmSize: (json["farm_size"] ?? 0).toDouble(),
      soilType: json["soil_type"] ?? "",
      irrigationMethod: json["irrigation_method"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "farm_name": farmName,
      "farm_size": farmSize,
      "soil_type": soilType,
      "irrigation_method": irrigationMethod,
    };
  }
}

class UserInfo {
  final String name;
  final String email;
  final String picture;

  UserInfo({required this.name, required this.email, required this.picture});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      picture: json["picture"] ?? "",
    );
  }
}
