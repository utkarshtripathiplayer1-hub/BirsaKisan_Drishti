class WeatherForecastResponse {
  final LocationData location;
  final List<ForecastData> forecast;
  final String source;

  WeatherForecastResponse({
    required this.location,
    required this.forecast,
    required this.source,
  });

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    return WeatherForecastResponse(
      location: LocationData.fromJson(json['location'] ?? {}),
      forecast: (json['forecast'] as List? ?? [])
          .map((e) => ForecastData.fromJson(e))
          .toList(),
      source: json['source'] ?? '',
    );
  }
}

class LocationData {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timezone: json['timezone'] ?? '',
      elevation: (json['elevation'] ?? 0).toDouble(),
    );
  }
}

class ForecastData {
  final String time;
  final double temperature;
  final double humidity;
  final double precipitationProbability;
  final double precipitation;
  final double rain;
  final int weatherCode;
  final String condition;
  final double cloudCover;
  final double windSpeed;
  final double windGust;

  ForecastData({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.precipitationProbability,
    required this.precipitation,
    required this.rain,
    required this.weatherCode,
    required this.condition,
    required this.cloudCover,
    required this.windSpeed,
    required this.windGust,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      time: json['time'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      precipitationProbability: (json['precipitation_probability'] ?? 0)
          .toDouble(),
      precipitation: (json['precipitation'] ?? 0).toDouble(),
      rain: (json['rain'] ?? 0).toDouble(),
      weatherCode: (json['weather_code'] ?? 0).toInt(),
      condition: json['condition'] ?? '',
      cloudCover: (json['cloud_cover'] ?? 0).toDouble(),
      windSpeed: (json['wind_speed'] ?? 0).toDouble(),
      windGust: (json['wind_gust'] ?? 0).toDouble(),
    );
  }
}
