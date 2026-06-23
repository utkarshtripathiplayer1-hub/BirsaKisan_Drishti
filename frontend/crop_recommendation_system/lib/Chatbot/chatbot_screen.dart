import 'package:crop_recommendation_system/Chatbot/chat_history_screen.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  final Map<String, dynamic>? conversationData;

  const ChatbotScreen({super.key, this.conversationData});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final ChatbotService service = ChatbotService();

  List<Map<String, dynamic>> messages = [];

  bool isLoading = false;

  String? currentConversationId;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.conversationData != null) {
      currentConversationId = widget.conversationData!["conversation_id"];

      final oldMessages = widget.conversationData!["messages"];

      for (final msg in oldMessages) {
        messages.add({
          "text": msg["original_text"],
          "isUser": msg["role"] == "user",
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized && widget.conversationData == null) {
      _initialized = true;

      messages.add({
        "text": AppLocalizations.of(context)!.chatBotMessage,
        "isUser": false,
      });
    }
  }

  Future<void> sendMessage() async {
    final query = _messageController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      messages.add({"text": query, "isUser": true});

      isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await service.sendMessage(
        userId: "test_user",
        domain: "agriculture",
        language: "English",
        query: query,
        conversationId: currentConversationId,
      );
      print("Conversation ID: $currentConversationId");
      currentConversationId = response["conversation_id"];

      setState(() {
        messages.add({"text": response["response"], "isUser": false});
      });
    } catch (e) {
      print("ERROR => $e");

      setState(() {
        messages.add({
          "text": "Sorry, unable to connect to server.",
          "isUser": false,
        });
      });

      Get.snackbar(AppLocalizations.of(context)!.error, e.toString());
    }

    setState(() {
      isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> loadConversation() async {
    try {
      final oldMessages = await service.getConversation(currentConversationId!);

      setState(() {
        messages.clear();

        for (final msg in oldMessages) {
          messages.add({
            "text": msg["message"],
            "isUser": msg["role"] == "user",
          });
        }
      });
    } catch (e) {
      Get.snackbar(AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.failLoadConvo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        title: Text(
          AppLocalizations.of(context)!.chatBot,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ChatHistoryScreen());
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  return ListTile(title: Text(AppLocalizations.of(context)!.typing));
                }
                final msg = messages[index];
                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg["isUser"]
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF067A34),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: AppLocalizations.of(context)!.askAnything,),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
