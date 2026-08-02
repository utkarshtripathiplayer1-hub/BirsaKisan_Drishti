import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CORE_URL']!;
}

class ChatbotVoiceService {
  Future<Map<String, dynamic>> sendVoiceMessage({
    required String audioPath,
    required String domain,
    required String? conversationId,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiConfig.baseUrl}/voice/chat"
        "?domain=$domain"
        "&conversation_id=$conversationId",
      ),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.fields["domain"] = domain;

    if (conversationId != null) {
      request.fields["conversation_id"] = conversationId;
    }

    request.files.add(await http.MultipartFile.fromPath("audio", audioPath));

    print("Final URL: ${request.url}");

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Voice request failed");
  }
}
