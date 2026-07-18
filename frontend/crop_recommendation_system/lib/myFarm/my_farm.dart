import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:crop_recommendation_system/myFarm/my_farm_controller.dart';
import 'package:crop_recommendation_system/myFarm/my_farm_model.dart';

class MyFarmPage extends StatefulWidget {
  const MyFarmPage({super.key});

  @override
  State<MyFarmPage> createState() => _MyFarmPageState();
}

class _MyFarmPageState extends State<MyFarmPage> {
  late Future<MyFarmModel> dashboardFuture;

  final controller = MyFarmController();

  @override
  void initState() {
    super.initState();
    dashboardFuture = controller.getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Farm",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        elevation: 0,
      ),
      body: FutureBuilder<MyFarmModel>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No Data"));
          }

          final farm = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _currentCropCard(farm),

                const SizedBox(height: 20),

                // _recommendationCard(farm),

                // const SizedBox(height: 20),

                // _cropDetailsCard(farm),

                // const SizedBox(height: 20),

                // _npkCard(farm),

                // const SizedBox(height: 20),
                _soilCard(farm),

                const SizedBox(height: 20),

                _weatherCard(farm),

                const SizedBox(height: 20),

                _locationCard(farm),

                const SizedBox(height: 20),

                _rotationCard(farm),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget item(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text("$title : $value"),
    );
  }

  Widget _rotationCard(MyFarmModel farm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.autorenew_rounded, color: Colors.green.shade900),
              SizedBox(width: 8),
              Text(
                "CROP ROTATION",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _rotationCropBox(
                  title: "Current Crop",
                  crop: farm.rotation.currentCrop,
                  color: Colors.green,
                  icon: Icons.grass,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.green,
                  size: 30,
                ),
              ),

              Expanded(
                child: _rotationCropBox(
                  title: "Next Crop",
                  crop: farm.rotation.nextCrop,
                  color: Colors.orange,
                  icon: Icons.eco,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.green.shade900),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Why this rotation?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        farm.rotation.reason,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rotationCropBox({
    required String title,
    required String crop,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),

          const SizedBox(height: 8),

          Text(
            crop,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentCropCard(MyFarmModel farm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CURRENT CROP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.grass,
                  size: 38,
                  color: Colors.green.shade900,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.currentCrop.cropName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        farm.currentCrop.status,
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              CircularPercentIndicator(
                radius: 42,
                lineWidth: 9,
                animation: true,
                percent: farm.currentCrop.progress / 100,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                center: Text(
                  "${farm.currentCrop.progress.toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: _infoTile(
                  Icons.calendar_today,
                  "Planted On",
                  farm.currentCrop.plantedOn.toString().split('T').first,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _infoTile(
                  Icons.event_available,
                  "Harvest",
                  farm.currentCrop.expectedHarvest.toString().split('T').first,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _infoTile(
                  Icons.check_circle,
                  "Completed",
                  "${farm.currentCrop.daysCompleted} Days",
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _infoTile(
                  Icons.timelapse,
                  "Remaining",
                  "${farm.currentCrop.daysRemaining} Days",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xffF7FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade900, size: 22),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _soilCard(MyFarmModel farm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SOIL HEALTH",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _soilMetric("Health", farm.soil.health, Icons.favorite),
              ),

              Expanded(
                child: _soilMetric(
                  "Score",
                  farm.soil.score.toString(),
                  Icons.star,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _soilMetric("Type", farm.soil.type, Icons.landscape),
              ),

              Expanded(
                child: _soilMetric(
                  "Moisture",
                  "${farm.soil.moisture}%",
                  Icons.water_drop,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // const Divider(),

          // const SizedBox(height: 7),
          _detailRow(Icons.science, "pH", farm.soil.ph.toString()),
          _detailRow(Icons.eco, "Nitrogen", farm.soil.n.toString()),
          _detailRow(Icons.spa, "Phosphorus", farm.soil.p.toString()),
          _detailRow(Icons.grass, "Potassium", farm.soil.k.toString()),
        ],
      ),
    );
  }

  Widget _soilMetric(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(fontSize: 13)),

          const SizedBox(height: 5),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard(MyFarmModel farm) {
    if (farm.weather == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Weather data not available",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    final weather = farm.weather!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "WEATHER",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _weatherRow(Icons.location_city, "City", weather.city),

          _weatherRow(
            Icons.thermostat,
            "Temperature",
            "${weather.temperature} °C",
          ),

          _weatherRow(Icons.water_drop, "Humidity", "${weather.humidity} %"),

          _weatherRow(Icons.cloud, "Condition", weather.condition),

          _weatherRow(Icons.description, "Description", weather.description),

          _weatherRow(Icons.air, "Wind Speed", "${weather.windSpeed} km/h"),

          _weatherRow(Icons.speed, "Pressure", "${weather.pressure} hPa"),

          _weatherRow(
            Icons.thermostat_auto,
            "Feels Like",
            "${weather.feelsLike} °C",
          ),
        ],
      ),
    );
  }

  Widget _weatherRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _locationCard(MyFarmModel farm) {
    if (farm.location == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Location data not available",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    final location = farm.location!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "LOCATION",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _locationRow(Icons.public, "Country", location.country),

          _locationRow(Icons.map, "State", location.state),

          _locationRow(Icons.location_city, "District", location.district),

          _locationRow(Icons.home, "Village", location.village),

          // const Divider(height: 30),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _coordinateCard(
                  Icons.my_location,
                  "Latitude",
                  location.latitude.toStringAsFixed(6),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _coordinateCard(
                  Icons.explore,
                  "Longitude",
                  location.longitude.toStringAsFixed(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _coordinateCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.red, size: 28),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // Widget _recommendationCard(MyFarmModel farm) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(22),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withValues(alpha: 0.12),
  //           blurRadius: 15,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "RECOMMENDATION",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
  //         ),

  //         const SizedBox(height: 20),

  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(15),
  //               decoration: BoxDecoration(
  //                 color: Colors.orange.shade50,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(Icons.eco, color: Colors.orange.shade700, size: 32),
  //             ),

  //             const SizedBox(width: 16),

  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     farm.recommendedCrop,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                   ),

  //                   const SizedBox(height: 6),

  //                   Text(
  //                     "Confidence : ${farm.confidence.toStringAsFixed(1)} %",
  //                     style: TextStyle(
  //                       color: Colors.grey.shade700,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _cropDetailsCard(MyFarmModel farm) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(22),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withValues(alpha: 0.12),
  //           blurRadius: 15,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "CROP DETAILS",
  //           style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  //         ),

  //         const SizedBox(height: 18),

  //         _detailRow(Icons.science, "Ideal pH", farm.cropDetails.idealPh),
  //         _detailRow(
  //           Icons.thermostat,
  //           "Temperature",
  //           farm.cropDetails.idealTemperature,
  //         ),
  //         _detailRow(
  //           Icons.water_drop,
  //           "Humidity",
  //           farm.cropDetails.idealHumidity,
  //         ),
  //         _detailRow(
  //           Icons.opacity,
  //           "Soil Moisture",
  //           farm.cropDetails.idealSoilMoisture,
  //         ),
  //         _detailRow(
  //           Icons.water,
  //           "Water Requirement",
  //           farm.cropDetails.waterRequirement,
  //         ),
  //         _detailRow(
  //           Icons.repeat,
  //           "Irrigation",
  //           farm.cropDetails.irrigationFrequency,
  //         ),
  //         _detailRow(
  //           Icons.waves,
  //           "Seasonal Water",
  //           farm.cropDetails.seasonalWaterNeed,
  //         ),
  //         _detailRow(Icons.wb_sunny, "Season", farm.cropDetails.season),
  //         _detailRow(
  //           Icons.calendar_month,
  //           "Duration",
  //           farm.cropDetails.duration,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _npkCard(MyFarmModel farm) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(22),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withValues(alpha: 0.12),
  //           blurRadius: 15,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "RECOMMENDED NPK",
  //           style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  //         ),

  //         const SizedBox(height: 18),

  //         Row(
  //           children: [
  //             Expanded(
  //               child: _npkBox(
  //                 "N",
  //                 farm.cropDetails.recommendedNPK.n.toString(),
  //                 Colors.green,
  //               ),
  //             ),

  //             const SizedBox(width: 14),

  //             Expanded(
  //               child: _npkBox(
  //                 "P",
  //                 farm.cropDetails.recommendedNPK.p.toString(),
  //                 Colors.orange,
  //               ),
  //             ),

  //             const SizedBox(width: 14),

  //             Expanded(
  //               child: _npkBox(
  //                 "K",
  //                 farm.cropDetails.recommendedNPK.k.toString(),
  //                 Colors.blue,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _npkBox(String title, String value, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 18),
  //     decoration: BoxDecoration(
  //       color: color.withValues(alpha: 0.08),
  //       borderRadius: BorderRadius.circular(18),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),

  //         const SizedBox(height: 8),

  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: color,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
