import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final UserModel user;
  final bool isNewUser;

  AuthResponse({
    required this.accessToken,
    required this.user,
    required this.isNewUser,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json["access_token"],
      user: UserModel.fromJson(json["user"]),
      isNewUser: json["is_new_user"] ?? false,
    );
  }
}
