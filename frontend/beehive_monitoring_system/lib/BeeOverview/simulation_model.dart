class ApiarySimulationModel {
  final String apiaryId;
  final String apiaryName;
  final int hiveCount;
  final String dataSource;
  final String scenario;
  final String simulationStatus;
  final String timestamp;
  final List<HiveModel> hives;

  ApiarySimulationModel({
    required this.apiaryId,
    required this.apiaryName,
    required this.hiveCount,
    required this.dataSource,
    required this.scenario,
    required this.simulationStatus,
    required this.timestamp,
    required this.hives,
  });

  factory ApiarySimulationModel.fromJson(Map<String, dynamic> json) {
    return ApiarySimulationModel(
      apiaryId: json['apiary_id'] ?? '',
      apiaryName: json['apiary_name'] ?? '',
      hiveCount: json['hive_count'] ?? 0,
      dataSource: json['data_source'] ?? '',
      scenario: json['scenario'] ?? '',
      simulationStatus: json['simulation_status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      hives: (json['hives'] as List<dynamic>? ?? [])
          .map((hive) => HiveModel.fromJson(hive))
          .toList(),
    );
  }
}

class HiveModel {
  final String hiveId;
  final String hiveName;
  final String status;
  final SensorReading sensorReading;
  final Prediction prediction;

  HiveModel({
    required this.hiveId,
    required this.hiveName,
    required this.status,
    required this.sensorReading,
    required this.prediction,
  });

  factory HiveModel.fromJson(Map<String, dynamic> json) {
    return HiveModel(
      hiveId: json['hive_id'] ?? '',
      hiveName: json['hive_name'] ?? '',
      status: json['status'] ?? '',
      sensorReading: SensorReading.fromJson(json['sensor_reading'] ?? {}),
      prediction: Prediction.fromJson(json['prediction'] ?? {}),
    );
  }
}

class SensorReading {
  final String timestamp;
  final double outsideTemperature;
  final double outsideHumidity;
  final double broodTemperature;
  final double overallTemperature;
  final double humidity;
  final double hiveWeight;
  final double weightChange24h;
  final double foragingActivity;
  final double acousticDb;
  final double vibrationIndex;
  final double co2;
  final double voc;
  final double broodTemperatureDeviation;

  SensorReading({
    required this.timestamp,
    required this.outsideTemperature,
    required this.outsideHumidity,
    required this.broodTemperature,
    required this.overallTemperature,
    required this.humidity,
    required this.hiveWeight,
    required this.weightChange24h,
    required this.foragingActivity,
    required this.acousticDb,
    required this.vibrationIndex,
    required this.co2,
    required this.voc,
    required this.broodTemperatureDeviation,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      timestamp: json['timestamp'] ?? '',
      outsideTemperature: (json['outside_temperature_c'] ?? 0).toDouble(),
      outsideHumidity: (json['outside_humidity_percent'] ?? 0).toDouble(),
      broodTemperature: (json['brood_temperature_c'] ?? 0).toDouble(),
      overallTemperature: (json['overall_temperature_c'] ?? 0).toDouble(),
      humidity: (json['humidity_percent'] ?? 0).toDouble(),
      hiveWeight: (json['hive_weight_kg'] ?? 0).toDouble(),
      weightChange24h: (json['weight_change_24h_kg'] ?? 0).toDouble(),
      foragingActivity: (json['foraging_activity_index'] ?? 0).toDouble(),
      acousticDb: (json['acoustic_db'] ?? 0).toDouble(),
      vibrationIndex: (json['vibration_index'] ?? 0).toDouble(),
      co2: (json['co2_ppm'] ?? 0).toDouble(),
      voc: (json['voc_index_ppm'] ?? 0).toDouble(),
      broodTemperatureDeviation: (json['brood_temp_deviation_c'] ?? 0)
          .toDouble(),
    );
  }
}

class Prediction {
  final String broodHealth;
  final String ventilation;
  final String colonyStress;
  final String honeyProduction;
  final String queenStatus;
  final String overallHealth;
  final String fungalRisk;
  final String diseaseRisk;

  Prediction({
    required this.broodHealth,
    required this.ventilation,
    required this.colonyStress,
    required this.honeyProduction,
    required this.queenStatus,
    required this.overallHealth,
    required this.fungalRisk,
    required this.diseaseRisk,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      broodHealth: json['brood_health'] ?? '',
      ventilation: json['ventilation'] ?? '',
      colonyStress: json['colony_stress'] ?? '',
      honeyProduction: json['honey_production'] ?? '',
      queenStatus: json['queen_status'] ?? '',
      overallHealth: json['overall_health'] ?? '',
      fungalRisk: json['fungal_risk'] ?? '',
      diseaseRisk: json['disease_risk'] ?? '',
    );
  }
}
