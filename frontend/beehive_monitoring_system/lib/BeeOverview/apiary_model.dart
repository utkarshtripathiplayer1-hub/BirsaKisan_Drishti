class ApiaryModel {
  final String id;
  final String name;
  final String description;
  final int targetHiveCount;
  final int hiveCount;
  final String hiveType;
  final String country;
  final String state;
  final String district;
  final String village;
  final double latitude;
  final double longitude;
  final String status;
  final String createdAt;

  ApiaryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.targetHiveCount,
    required this.hiveCount,
    required this.hiveType,
    required this.country,
    required this.state,
    required this.district,
    required this.village,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory ApiaryModel.fromJson(Map<String, dynamic> json) {
    return ApiaryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      targetHiveCount: json['target_hive_count'] ?? 0,
      hiveCount: json['hive_count'] ?? 0,
      hiveType: json['hive_type'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      village: json['village'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
