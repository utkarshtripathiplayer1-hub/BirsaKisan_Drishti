import 'dart:convert';
import 'package:http/http.dart' as http;

import 'conversation_model.dart';

class ChatbotService {
  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String domain,
    required String language,
    required String query,
    String? conversationId,
  }) async {
    final response = await http.post(
      Uri.parse("https://remedy-factsheet-empirical.ngrok-free.dev/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "domain": domain,
        "language": language,
        "query": query,
        "conversation_id": conversationId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to send message");
  }

  Future<List<ConversationModel>> getConversations({
    required String userId,
    required String domain,
  }) async {
    final response = await http.get(
      Uri.parse(
        "https://remedy-factsheet-empirical.ngrok-free.dev/conversations"
        "?user_id=$userId"
        "&domain=$domain",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data as List).map((e) => ConversationModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load conversations");
  }

  Future<dynamic> getConversation(String conversationId) async {
    final response = await http.get(
      Uri.parse(
        "https://remedy-factsheet-empirical.ngrok-free.dev/conversations/$conversationId",
      ),
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
    final response = await http.patch(
      Uri.parse(
        "https://remedy-factsheet-empirical.ngrok-free.dev/conversations/$conversationId",
      ),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"title": title}),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Rename failed");
    }
  }

  Future<void> deleteConversation({required String conversationId}) async {
    final response = await http.delete(
      Uri.parse(
        "https://remedy-factsheet-empirical.ngrok-free.dev/conversations/$conversationId",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Delete failed");
    }
  }
}
