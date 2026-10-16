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

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final uri = Uri.parse("${ApiConfig.baseUrl}/api/voice/chat");

    final request = http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = "Bearer $token";

    request.fields["domain"] = domain;

    if (conversationId != null && conversationId.isNotEmpty) {
      request.fields["conversation_id"] = conversationId;
    }

    request.files.add(await http.MultipartFile.fromPath("audio", audioPath));

    print("Voice conversation ID: $conversationId");
    print("Final URL: ${request.url}");
    print("➡️ Multipart conversation_id = ${request.fields["conversation_id"]}");

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
    print("status: ${jsonDecode(response.body)['audio_base64']}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Voice request failed: ${response.body}");
  }
}
