import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_daily_controller.dart';
import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_daily_model.dart';
import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_hourly_controller.dart';
import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_hourly_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherForecastScreen extends StatelessWidget {
  WeatherForecastScreen({super.key});

  final WeatherForecastController controller = Get.put(
    WeatherForecastController(),
  );
  final WeatherForecastDailyController dailyController = Get.put(
    WeatherForecastDailyController(),
  );
  final RxInt selectedForecast = 0.obs;
  final RxInt selectedDay = 0.obs;
  final RxInt selectedHour = 0.obs;

  String formatDate(String date) {
    final dateTime = DateTime.parse(date);

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${dateTime.day} ${months[dateTime.month - 1]}";
  }

  String formatDay(String date) {
    final dateTime = DateTime.parse(date);

    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[dateTime.weekday - 1];
  }

  List<ForecastData> getFiveHours(List<ForecastData> allForecast) {
    if (allForecast.isEmpty) {
      print("❌ Forecast list is EMPTY");
      return [];
    }

    final now = DateTime.now();

    // Current hour
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);

    // 1 hour before
    final startTime = currentHour.subtract(const Duration(hours: 1));

    // 3 hours after
    final endTime = currentHour.add(const Duration(hours: 3));

    print("=================================");
    print("CURRENT TIME: $now");
    print("START TIME:   $startTime");
    print("END TIME:     $endTime");
    print("TOTAL DATA:   ${allForecast.length}");
    print("=================================");

    final filteredForecast = <ForecastData>[];

    for (final weather in allForecast) {
      try {
        final weatherTime = DateTime.parse(weather.time);

        print(
          "Backend time: ${weather.time} "
          "→ Parsed: $weatherTime",
        );

        if (!weatherTime.isBefore(startTime) && !weatherTime.isAfter(endTime)) {
          filteredForecast.add(weather);

          print("✅ INCLUDED: ${weather.time}");
        } else {
          print("❌ OUTSIDE RANGE: ${weather.time}");
        }
      } catch (e) {
        print("❌ TIME PARSE ERROR: ${weather.time}");
        print(e);
      }
    }

    filteredForecast.sort((a, b) {
      final timeA = DateTime.parse(a.time);
      final timeB = DateTime.parse(b.time);

      return timeA.compareTo(timeB);
    });

    print("=================================");
    print("FINAL 5-HOUR COUNT: ${filteredForecast.length}");
    print("=================================");

    return filteredForecast;
  }

  String formatHour(String time) {
    final dateTime = DateTime.parse(time);

    final hour = dateTime.hour;

    if (hour == 0) {
      return "12 AM";
    }

    if (hour == 12) {
      return "12 PM";
    }

    if (hour > 12) {
      return "${hour - 12} PM";
    }

    return "$hour AM";
  }

  Widget buildSevenDaysForecast() {
    return Obx(() {
      // Loading
      if (dailyController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Error
      if (dailyController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            "Weather forecast not available",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        );
      }

      // No data
      if (dailyController.forecast.isEmpty) {
        return const Center(child: Text("Weather forecast not available"));
      }

      // Safety check
      if (selectedDay.value >= dailyController.forecast.length) {
        selectedDay.value = 0;
      }

      final selectedWeather = dailyController.forecast[selectedDay.value];

      return Column(
        children: [
          // --------------------------------
          // HORIZONTAL DAY CARDS
          // --------------------------------
          SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: dailyController.forecast.length,
              itemBuilder: (context, index) {
                final weather = dailyController.forecast[index];

                final isSelected = selectedDay.value == index;

                return GestureDetector(
                  onTap: () {
                    selectedDay.value = index;
                  },
                  child: Container(
                    width: 82,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green.shade700
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Day
                        Text(
                          formatDay(weather.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.green.shade800
                                : Colors.grey.shade700,
                          ),
                        ),

                        // Date
                        Text(
                          formatDate(weather.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.green.shade800
                                : Colors.grey.shade600,
                          ),
                        ),

                        // Weather icon
                        Icon(
                          getWeatherIcon(weather.weatherCode),
                          size: 38,
                          color: isSelected
                              ? Colors.green.shade700
                              : Colors.blue.shade600,
                        ),

                        // Temperature
                        Text(
                          "${weather.temperatureMax.round()}° / "
                          "${weather.temperatureMin.round()}°",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.green.shade800
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // --------------------------------
          // SELECTED DAY DETAILS
          // --------------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: buildSelectedDayDetails(selectedWeather),
            ),
          ),
        ],
      );
    });
  }

  Widget buildSelectedDayDetails(DailyForecast weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------
          // TITLE
          // --------------------------------
          Text(
            "Day Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            "${formatDay(weather.date)}, ${formatDate(weather.date)}",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 18),

          // --------------------------------
          // MAIN WEATHER
          // --------------------------------
          Row(
            children: [
              Icon(
                getWeatherIcon(weather.weatherCode),
                size: 60,
                color: Colors.blue.shade600,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.condition,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "${weather.temperatureMax.round()}° / "
                      "${weather.temperatureMin.round()}°",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Feels like "
                      "${weather.apparentTemperatureMax.round()}° / "
                      "${weather.apparentTemperatureMin.round()}°",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --------------------------------
          // WEATHER INFORMATION
          // --------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                buildWeatherInfoRow(
                  Icons.water_drop,
                  "Rain",
                  "${weather.rain.toStringAsFixed(1)} mm",
                ),

                const SizedBox(height: 12),

                buildWeatherInfoRow(
                  Icons.umbrella,
                  "Rain Probability",
                  "${weather.precipitationProbability.round()}%",
                ),

                const SizedBox(height: 12),

                buildWeatherInfoRow(
                  Icons.air,
                  "Wind",
                  "${weather.windSpeedMax.round()} km/h",
                ),

                const SizedBox(height: 12),

                buildWeatherInfoRow(
                  Icons.air,
                  "Wind Gust",
                  "${weather.windGustMax.round()} km/h",
                ),

                const SizedBox(height: 12),

                buildWeatherInfoRow(
                  Icons.water,
                  "Precipitation",
                  "${weather.precipitation.toStringAsFixed(1)} mm",
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // --------------------------------
          // SUNRISE / SUNSET
          // --------------------------------
          Row(
            children: [
              Expanded(
                child: buildSunInfo(
                  Icons.wb_sunny_outlined,
                  "Sunrise",
                  formatTime(weather.sunrise),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: buildSunInfo(
                  Icons.nights_stay_outlined,
                  "Sunset",
                  formatTime(weather.sunset),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWeatherInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 21, color: Colors.green.shade700),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget buildSunInfo(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade600, size: 24),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(String time) {
    if (time.isEmpty) {
      return "--";
    }

    try {
      final dateTime = DateTime.parse(time);

      final hour = dateTime.hour;
      final minute = dateTime.minute;

      final period = hour >= 12 ? "PM" : "AM";

      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return "$displayHour:${minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return "--";
    }
  }

  IconData getWeatherIcon(int weatherCode) {
    if (weatherCode == 0) {
      return Icons.wb_sunny;
    }

    if (weatherCode == 1 || weatherCode == 2 || weatherCode == 3) {
      return Icons.cloud;
    }

    if (weatherCode == 45 || weatherCode == 48) {
      return Icons.foggy;
    }

    if (weatherCode >= 51 && weatherCode <= 67) {
      return Icons.grain;
    }

    if (weatherCode >= 71 && weatherCode <= 77) {
      return Icons.ac_unit;
    }

    if (weatherCode >= 80 && weatherCode <= 82) {
      return Icons.water_drop;
    }

    if (weatherCode >= 95) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  Widget buildHourlyInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,

          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(7),
          ),

          child: Icon(icon, size: 18, color: Colors.blue.shade600),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,

            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),

        Text(
          value,

          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Forecast")),

      body: Column(
        children: [
          // =====================================================
          // TOP TOGGLE BAR
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),

            child: Container(
              height: 48,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Obx(
                () => Row(
                  children: [
                    // =================================================
                    // HOURLY BUTTON
                    // =================================================

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedForecast.value = 0;
                        },

                        child: Container(
                          height: 48,

                          decoration: BoxDecoration(
                            color: selectedForecast.value == 0
                                ? Colors.green.shade700
                                : Colors.white,

                            borderRadius: BorderRadius.circular(25),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            "Hourly",

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                              color: selectedForecast.value == 0
                                  ? Colors.white
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // =================================================
                    // 7 DAYS BUTTON
                    // =================================================
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedForecast.value = 1;
                        },

                        child: Container(
                          height: 48,

                          decoration: BoxDecoration(
                            color: selectedForecast.value == 1
                                ? Colors.green.shade700
                                : Colors.white,

                            borderRadius: BorderRadius.circular(25),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            "7 Days",

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                              color: selectedForecast.value == 1
                                  ? Colors.white
                                  : Colors.green.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // WEATHER CONTENT
          // =====================================================
          Expanded(
            child: Obx(() {
              // =================================================
              // HOURLY WEATHER
              // =================================================

              if (selectedForecast.value == 0) {
                // Hourly loading
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Hourly error
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final fiveHours = getFiveHours(controller.forecast);

                // No hourly data
                if (fiveHours.isEmpty) {
                  return const Center(
                    child: Text(
                      "Weather Updating. Please wait",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // =================================================
                // YOUR EXISTING HOURLY UI
                // =================================================

                // =================================================
                // REDESIGNED HOURLY UI
                // =================================================

                return Obx(() {
                  final selectedWeather = fiveHours[selectedHour.value];

                  return Column(
                    children: [
                      // =================================================
                      // HORIZONTAL HOURLY CARDS
                      // =================================================

                      SizedBox(
                        height: 245,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                          itemCount: fiveHours.length,
                          itemBuilder: (context, index) {
                            final weather = fiveHours[index];

                            final isSelected = selectedHour.value == index;

                            return GestureDetector(
                              onTap: () {
                                selectedHour.value = index;
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),

                                width: 145,

                                margin: const EdgeInsets.only(right: 12),

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 14,
                                ),

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.green.shade50
                                      : Colors.white,

                                  borderRadius: BorderRadius.circular(18),

                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green.shade700
                                        : Colors.grey.shade200,

                                    width: isSelected ? 2 : 1,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    // ==========================
                                    // TIME
                                    // ==========================

                                    Text(
                                      index == 0
                                          ? "Now"
                                          : formatHour(weather.time),

                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.green.shade800
                                            : Colors.grey.shade800,
                                      ),
                                    ),

                                    // ==========================
                                    // WEATHER ICON
                                    // ==========================
                                    Icon(
                                      getWeatherIcon(weather.weatherCode),
                                      size: 65,
                                      color: Colors.blue.shade600,
                                    ),

                                    // ==========================
                                    // CONDITION
                                    // ==========================
                                    Text(
                                      weather.condition,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,

                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),

                                    // ==========================
                                    // TEMPERATURE
                                    // ==========================
                                    Text(
                                      "${weather.temperature.round()}°",

                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.green.shade800
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // =================================================
                      // HOURLY DETAILS
                      // =================================================
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),

                          child: Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(20),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // ==========================
                                // TITLE
                                // ==========================

                                const Text(
                                  "Hourly Details",

                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  selectedHour.value == 0
                                      ? "Now"
                                      : formatHour(selectedWeather.time),

                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ==========================
                                // MAIN WEATHER
                                // ==========================
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Icon(
                                      getWeatherIcon(
                                        selectedWeather.weatherCode,
                                      ),

                                      size: 72,

                                      color: Colors.blue.shade600,
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            selectedWeather.condition,

                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          Text(
                                            "${selectedWeather.temperature.round()}°C",

                                            style: TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // ==========================
                                // WEATHER INFORMATION
                                // ==========================
                                Container(
                                  width: double.infinity,

                                  padding: const EdgeInsets.all(15),

                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,

                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                  child: Column(
                                    children: [
                                      buildHourlyInfoRow(
                                        Icons.water_drop,
                                        "Humidity",
                                        "${selectedWeather.humidity.round()}%",
                                      ),

                                      const SizedBox(height: 13),

                                      buildHourlyInfoRow(
                                        Icons.umbrella,
                                        "Rain Probability",
                                        "${selectedWeather.precipitationProbability.round()}%",
                                      ),

                                      const SizedBox(height: 13),

                                      buildHourlyInfoRow(
                                        Icons.water,
                                        "Rainfall",
                                        "${selectedWeather.rain.toStringAsFixed(1)} mm",
                                      ),

                                      const SizedBox(height: 13),

                                      buildHourlyInfoRow(
                                        Icons.air,
                                        "Wind",
                                        "${selectedWeather.windSpeed.round()} km/h",
                                      ),

                                      const SizedBox(height: 13),

                                      buildHourlyInfoRow(
                                        Icons.cloud,
                                        "Cloud Cover",
                                        "${selectedWeather.cloudCover.round()}%",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
              }

              // =================================================
              // 7 DAYS WEATHER
              // =================================================

              // =================================================
              // 7 DAYS WEATHER
              // =================================================

              return Obx(() {
                // Daily loading
                if (dailyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Daily error
                if (dailyController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      dailyController.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // No daily data
                if (dailyController.forecast.isEmpty) {
                  return const Center(
                    child: Text(
                      "7 day forecast not available",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // Safety check
                if (selectedDay.value >= dailyController.forecast.length) {
                  selectedDay.value = 0;
                }

                final selectedWeather =
                    dailyController.forecast[selectedDay.value];

                return Column(
                  children: [
                    // =================================================
                    // HORIZONTAL DAY CARDS
                    // =================================================

                    SizedBox(
                      height: 145,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        itemCount: dailyController.forecast.length,
                        itemBuilder: (context, index) {
                          final weather = dailyController.forecast[index];

                          final isSelected = selectedDay.value == index;

                          return GestureDetector(
                            onTap: () {
                              selectedDay.value = index;
                            },

                            child: Container(
                              width: 82,
                              margin: const EdgeInsets.only(right: 8),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.green.shade50
                                    : Colors.white,

                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: isSelected
                                      ? Colors.green.shade700
                                      : Colors.grey.shade300,

                                  width: isSelected ? 1.5 : 1,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  // DAY
                                  Text(
                                    formatDay(weather.date),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,

                                      color: isSelected
                                          ? Colors.green.shade800
                                          : Colors.grey.shade700,
                                    ),
                                  ),

                                  // DATE
                                  Text(
                                    formatDate(weather.date),

                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.green.shade800
                                          : Colors.grey.shade600,
                                    ),
                                  ),

                                  // WEATHER ICON
                                  Icon(
                                    getWeatherIcon(weather.weatherCode),
                                    size: 38,
                                    color: Colors.blue.shade600,
                                  ),

                                  // TEMPERATURE
                                  Text(
                                    "${weather.temperatureMax.round()}° / "
                                    "${weather.temperatureMin.round()}°",

                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,

                                      color: isSelected
                                          ? Colors.green.shade800
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =================================================
                    // SELECTED DAY DETAILS
                    // =================================================
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),

                        child: buildSelectedDayDetails(selectedWeather),
                      ),
                    ),
                  ],
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
