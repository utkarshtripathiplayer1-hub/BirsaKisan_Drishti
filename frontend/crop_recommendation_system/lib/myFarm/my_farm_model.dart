class MyFarmModel {
  final CurrentCrop currentCrop;
  final String recommendedCrop;
  final double confidence;
  final CropDetails cropDetails;
  final Soil soil;
  final Weather? weather;
  final Location? location;
  final Rotation rotation;

  MyFarmModel({
    required this.currentCrop,
    required this.recommendedCrop,
    required this.confidence,
    required this.cropDetails,
    required this.soil,
    this.weather,
    this.location,
    required this.rotation,
  });

  factory MyFarmModel.fromJson(Map<String, dynamic> json) {
    return MyFarmModel(
      currentCrop: CurrentCrop.fromJson(json["current_crop"]),
      recommendedCrop: json["recommended_crop"],
      confidence: (json["confidence"] as num).toDouble(),
      cropDetails: CropDetails.fromJson(json["crop_details"]),
      soil: Soil.fromJson(json["soil"]),
      weather: json["weather"] != null
          ? Weather.fromJson(json["weather"])
          : null,
      location: json["location"] != null
          ? Location.fromJson(json["location"])
          : null,
      rotation: Rotation.fromJson(json["rotation"]),
    );
  }
}

class CurrentCrop {
  final String cropName;
  final String status;
  final String plantedOn;
  final String expectedHarvest;
  final int daysCompleted;
  final int daysRemaining;
  final double progress;

  CurrentCrop({
    required this.cropName,
    required this.status,
    required this.plantedOn,
    required this.expectedHarvest,
    required this.daysCompleted,
    required this.daysRemaining,
    required this.progress,
  });

  factory CurrentCrop.fromJson(Map<String, dynamic> json) {
    return CurrentCrop(
      cropName: json["crop_name"],
      status: json["status"],
      plantedOn: json["planted_on"],
      expectedHarvest: json["expected_harvest"],
      daysCompleted: (json["days_completed"] as num).toInt(),
      daysRemaining: (json["days_remaining"] as num).toInt(),
      progress: (json["progress"] as num).toDouble(),
    );
  }
}

class CropDetails {
  final RecommendedNPK recommendedNPK;
  final String idealPh;
  final String idealTemperature;
  final String idealHumidity;
  final String idealSoilMoisture;
  final String waterRequirement;
  final String irrigationFrequency;
  final String seasonalWaterNeed;
  final String season;
  final String duration;

  CropDetails({
    required this.recommendedNPK,
    required this.idealPh,
    required this.idealTemperature,
    required this.idealHumidity,
    required this.idealSoilMoisture,
    required this.waterRequirement,
    required this.irrigationFrequency,
    required this.seasonalWaterNeed,
    required this.season,
    required this.duration,
  });

  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails(
      recommendedNPK:
          RecommendedNPK.fromJson(json["recommended_npk"]),
      idealPh: json["ideal_ph"],
      idealTemperature: json["ideal_temperature"],
      idealHumidity: json["ideal_humidity"],
      idealSoilMoisture: json["ideal_soil_moisture"],
      waterRequirement: json["water_requirement"],
      irrigationFrequency: json["irrigation_frequency"],
      seasonalWaterNeed: json["seasonal_water_need"],
      season: json["season"],
      duration: json["duration"],
    );
  }
}

class RecommendedNPK {
  final int n;
  final int p;
  final int k;

  RecommendedNPK({
    required this.n,
    required this.p,
    required this.k,
  });

  factory RecommendedNPK.fromJson(Map<String, dynamic> json) {
    return RecommendedNPK(
      n: (json["N"] as num).toInt(),
      p: (json["P"] as num).toInt(),
      k: (json["K"] as num).toInt(),
    );
  }
}

class Soil {
  final String health;
  final int score;
  final String type;
  final double moisture;
  final double ph;
  final double n;
  final double p;
  final double k;

  Soil({
    required this.health,
    required this.score,
    required this.type,
    required this.moisture,
    required this.ph,
    required this.n,
    required this.p,
    required this.k,
  });

  factory Soil.fromJson(Map<String, dynamic> json) {
    return Soil(
      health: json["health"],
      score: (json["score"] as num).toInt(),
      type: json["type"],
      moisture: (json["moisture"] as num).toDouble(),
      ph: (json["ph"] as num).toDouble(),
      n: (json["N"] as num).toDouble(),
      p: (json["P"] as num).toDouble(),
      k: (json["K"] as num).toDouble(),
    );
  }
}

class Weather {
  final String city;
  final double temperature;
  final double humidity;
  final String condition;
  final String description;
  final double windSpeed;
  final double pressure;
  final double feelsLike;

  Weather({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.description,
    required this.windSpeed,
    required this.pressure,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json["city"],
      temperature: (json["temperature"] as num).toDouble(),
      humidity: (json["humidity"] as num).toDouble(),
      condition: json["condition"],
      description: json["description"],
      windSpeed: (json["wind_speed"] as num).toDouble(),
      pressure: (json["pressure"] as num).toDouble(),
      feelsLike: (json["feels_like"] as num).toDouble(),
    );
  }
}

class Location {
  final String country;
  final String state;
  final String district;
  final String village;
  final double latitude;
  final double longitude;

  Location({
    required this.country,
    required this.state,
    required this.district,
    required this.village,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json["country"],
      state: json["state"],
      district: json["district"],
      village: json["village"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
    );
  }
}

class Rotation {
  final String currentCrop;
  final String nextCrop;
  final String reason;

  Rotation({
    required this.currentCrop,
    required this.nextCrop,
    required this.reason,
  });

  factory Rotation.fromJson(Map<String, dynamic> json) {
    return Rotation(
      currentCrop: json["current_crop"],
      nextCrop: json["next_crop"],
      reason: json["reason"],
    );
  }
}