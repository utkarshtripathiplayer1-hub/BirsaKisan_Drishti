import 'dart:convert';
import 'package:crop_recommendation_system/Chatbot/chatbot_screen.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'chatbot_service.dart';
import 'conversation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ChatbotService service = ChatbotService();

  List<ConversationModel> conversations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      conversations = await service.getConversations(
        userId: "test_user",
        domain: "agriculture",
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  void showRenameDialog(ConversationModel item) {
    final controller = TextEditingController(text: item.title);

    Get.dialog(
      AlertDialog(
        title: Text(AppLocalizations.of(context)!.renameChat,),

        content: TextField(controller: controller),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),

          TextButton(
            onPressed: () async {
              await service.renameConversation(
                conversationId: item.conversationId,
                title: controller.text,
              );

              Get.back();

              loadConversations();
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(ConversationModel item) {
    Get.dialog(
      AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteConvo),

        content: Text(AppLocalizations.of(context)!.deleteConvoDesc,),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(AppLocalizations.of(context)!.no),
          ),

          TextButton(
            onPressed: () async {
              try {
                await service.deleteConversation(
                  conversationId: item.conversationId,
                );
              } catch (e) {
                Get.snackbar(AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.failDeleteConvo);
              }

              Get.back();

              loadConversations();
            },
            child: Text(AppLocalizations.of(context)!.yes,),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> getConversationMessages(String conversationId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/conversations/$conversationId"),
    );

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        backgroundColor: Colors.green.shade900,
        title: Text(AppLocalizations.of(context)!.chatHistory, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
        ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final item = conversations[index];

                return ListTile(
                  leading: Icon(Icons.chat, color: Colors.green.shade900,),

                  title: Text(item.title),

                  subtitle: Text(item.updatedAt),

                  trailing: PopupMenuButton<String>(
                    // iconColor: Colors.green.shade900,
                    onSelected: (value) {
                      if (value == "rename") {
                        showRenameDialog(item);
                      }

                      if (value == "delete") {
                        showDeleteDialog(item);
                      }
                    },

                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "rename",
                        child: Text(AppLocalizations.of(context)!.rename, style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold),),
                      ),

                      PopupMenuItem(
                        value: "delete",
                        child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  onTap: () async {
                    final data = await service.getConversation(
                      item.conversationId,
                    );

                    Get.to(() => ChatbotScreen(conversationData: data));
                  },
                );
              },
            ),
    );
  }
}
