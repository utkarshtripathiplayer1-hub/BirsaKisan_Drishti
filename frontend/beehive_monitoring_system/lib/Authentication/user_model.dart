class UserModel {
  final String id;
  final String name;
  final String email;
  final String picture;
  final String preferredLanguage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    required this.preferredLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      picture: json["picture"],
      preferredLanguage: json["preferred_language"],
    );
  }
}
