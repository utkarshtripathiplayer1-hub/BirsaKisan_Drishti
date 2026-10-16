class ApiaryModel {
  final String name;
  final String description;
  final int targetHiveCount;
  final String hiveType;
  final double latitude;
  final double longitude;
  final String country;
  final String state;
  final String district;
  final String village;

  ApiaryModel({
    required this.name,
    required this.description,
    required this.targetHiveCount,
    required this.hiveType,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.state,
    required this.district,
    required this.village,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'target_hive_count': targetHiveCount,
      'hive_type': hiveType,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'state': state,
      'district': district,
      'village': village,
    };
  }
}