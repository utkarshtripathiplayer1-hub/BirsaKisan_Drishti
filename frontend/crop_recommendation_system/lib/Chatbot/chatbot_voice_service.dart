import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class ChatbotVoiceService {
  Future<Map<String, dynamic>> sendVoiceMessage({
    required String audioPath,
    required String userId,
    required String language,
    required String domain,
    required String? conversationId,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiConfig.baseUrl}/voice/chat"
        "?user_id=$userId"
        "&language=$language"
        "&conversation_id=$conversationId",
      ),
    );

    request.fields["user_id"] = userId;
    request.fields["language"] = language;
    request.fields["domain"] = domain;

    if (conversationId != null) {
      request.fields["conversation_id"] = conversationId;
    }

    request.files.add(await http.MultipartFile.fromPath("audio", audioPath));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Voice request failed");
  }
}
