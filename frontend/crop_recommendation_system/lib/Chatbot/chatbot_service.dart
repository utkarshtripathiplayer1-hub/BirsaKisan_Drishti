import 'dart:convert';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'conversation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class ChatbotService {
  Future<Map<String, dynamic>> sendMessage({
    required String domain,
    required String query,
    String? conversationId,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/chat"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "domain": domain,
        "query": query,
        "conversation_id": conversationId,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to send message\n"
      "Status: ${response.statusCode}\n"
      "Body: ${response.body}",
    );
  }

  Future<List<ConversationModel>> getConversations({
    required String domain,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/conversations"
        "?domain=$domain",
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data as List).map((e) => ConversationModel.fromJson(e)).toList();
    }

    throw Exception(
      "Failed to load conversations"
      "Status: ${response.statusCode}\n"
      "Body: ${response.body}",
    );
  }

  Future<dynamic> getConversation(String conversationId) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/conversations/$conversationId"),
      headers: {"Authorization": "Bearer $token"},
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load conversation");
  }

  Future<void> renameConversation({
    required String conversationId,
    required String title,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/conversations/$conversationId"),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode({"title": title}),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Rename failed");
    }
  }

  Future<void> deleteConversation({required String conversationId}) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/conversations/$conversationId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Delete failed");
    }
  }
}
