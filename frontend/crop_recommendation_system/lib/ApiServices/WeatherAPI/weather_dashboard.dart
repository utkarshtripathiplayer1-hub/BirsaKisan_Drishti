import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_daily_controller.dart';
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
                    color: Colors.black.withOpacity(0.15),
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: fiveHours.length,

                  itemBuilder: (context, index) {
                    final weather = fiveHours[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Row(
                          children: [
                            // TIME
                            SizedBox(
                              width: 70,

                              child: Text(
                                formatHour(weather.time),

                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // WEATHER DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    weather.condition,

                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "Humidity: "
                                    "${weather.humidity}%",
                                  ),

                                  Text(
                                    "Rain probability: "
                                    "${weather.precipitationProbability}%",
                                  ),
                                ],
                              ),
                            ),

                            // TEMPERATURE
                            Text(
                              "${weather.temperature}°C",

                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

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

                // =================================================
                // 7 DAY LIST
                // =================================================

                return ListView(
                  padding: const EdgeInsets.all(16),

                  children: [
                    const Text(
                      "7 Day Forecast",

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...dailyController.forecast.map((weather) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            children: [
                              // DAY + DATE
                              SizedBox(
                                width: 100,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      formatDay(weather.date),

                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      formatDate(weather.date),

                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // CONDITION
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      weather.condition,

                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "Rain: "
                                      "${weather.precipitationProbability}%",
                                    ),
                                  ],
                                ),
                              ),

                              // TEMPERATURE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text(
                                    "${weather.temperatureMax}°C",

                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "${weather.temperatureMin}°C",

                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
