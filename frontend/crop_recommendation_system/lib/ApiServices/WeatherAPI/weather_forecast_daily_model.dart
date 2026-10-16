class DailyWeatherResponse {
  final DailyLocation location;
  final List<DailyForecast> forecast;
  final String source;

  DailyWeatherResponse({
    required this.location,
    required this.forecast,
    required this.source,
  });

  factory DailyWeatherResponse.fromJson(Map<String, dynamic> json) {
    return DailyWeatherResponse(
      location: DailyLocation.fromJson(json['location'] ?? {}),
      forecast: (json['forecast'] as List? ?? [])
          .map((e) => DailyForecast.fromJson(e))
          .toList(),
      source: json['source'] ?? '',
    );
  }
}

class DailyLocation {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;

  DailyLocation({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
  });

  factory DailyLocation.fromJson(Map<String, dynamic> json) {
    return DailyLocation(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timezone: json['timezone'] ?? '',
      elevation: (json['elevation'] ?? 0).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final double temperatureMax;
  final double temperatureMin;
  final double apparentTemperatureMax;
  final double apparentTemperatureMin;
  final double precipitation;
  final double rain;
  final double precipitationProbability;
  final int weatherCode;
  final String condition;
  final double windSpeedMax;
  final double windGustMax;
  final String sunrise;
  final String sunset;

  DailyForecast({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.precipitation,
    required this.rain,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.condition,
    required this.windSpeedMax,
    required this.windGustMax,
    required this.sunrise,
    required this.sunset,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'] ?? '',
      temperatureMax: (json['temperature_max'] ?? 0).toDouble(),
      temperatureMin: (json['temperature_min'] ?? 0).toDouble(),
      apparentTemperatureMax: (json['apparent_temperature_max'] ?? 0)
          .toDouble(),
      apparentTemperatureMin: (json['apparent_temperature_min'] ?? 0)
          .toDouble(),
      precipitation: (json['precipitation'] ?? 0).toDouble(),
      rain: (json['rain'] ?? 0).toDouble(),
      precipitationProbability: (json['precipitation_probability'] ?? 0)
          .toDouble(),
      weatherCode: (json['weather_code'] ?? 0).toInt(),
      condition: json['condition'] ?? '',
      windSpeedMax: (json['wind_speed_max'] ?? 0).toDouble(),
      windGustMax: (json['wind_gust_max'] ?? 0).toDouble(),
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
    );
  }
}
