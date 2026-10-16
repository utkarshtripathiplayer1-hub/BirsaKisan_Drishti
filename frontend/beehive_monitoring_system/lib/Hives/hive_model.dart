class HiveModel {
  final String name;
  final String description;
  final String hiveType;

  HiveModel({
    required this.name,
    required this.description,
    required this.hiveType,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'hive_type': hiveType};
  }
}
