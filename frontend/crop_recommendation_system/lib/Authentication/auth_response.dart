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
    // final userJson = json['user'] as Map<String, dynamic>;
    return AuthResponse(
      accessToken: json["access_token"],
      user: UserModel.fromJson(json["user"]),
      isNewUser: json["user"]["new_user_agriculture"] ?? false,
    );
  }
}
