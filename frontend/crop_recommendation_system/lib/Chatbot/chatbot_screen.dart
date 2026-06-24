import 'dart:io';
import 'package:crop_recommendation_system/Chatbot/chat_history_screen.dart';
import 'package:crop_recommendation_system/Chatbot/chatbot_voice_service.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatbot_service.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class ChatbotScreen extends StatefulWidget {
  final Map<String, dynamic>? conversationData;

  const ChatbotScreen({super.key, this.conversationData});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final AudioRecorder recorder = AudioRecorder();

  bool isRecording = false;

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final ChatbotService service = ChatbotService();

  List<Map<String, dynamic>> messages = [];

  bool isLoading = false;

  String? currentConversationId;

  bool _initialized = false;

  DateTime? recordingStartTime;

  bool isCancelled = false;

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
        messages.add({
          "text": response["response"].replaceAll("**", ""),
          "isUser": false,
        });
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

  Future<String> getAudioPath() async {
    final dir = await getTemporaryDirectory();

    return '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final path = await getAudioPath();

      await recorder.start(const RecordConfig(), path: path);

      recordingStartTime = DateTime.now();

      setState(() {
        isRecording = true;
        isCancelled = false;
      });
    }
  }

  Future<void> stopRecording() async {
    if (isCancelled) {
      return;
    }

    final path = await recorder.stop();

    final duration = DateTime.now().difference(recordingStartTime!);

    setState(() {
      isRecording = false;
    });

    if (duration.inMilliseconds < 1000) {
      isCancelled = true;
      return;
    }

    if (path != null) {
      final file = File(path);

      print("Audio path: $path");
      print("Audio size: ${await file.length()} bytes");
      await sendVoiceToBackend(path);
    }
  }

  void cancelRecording() async {
    isCancelled = true;

    await recorder.stop();

    setState(() {
      isRecording = false;
    });
  }

  Future<void> sendVoiceToBackend(String path) async {
    try {
      setState(() {
        isLoading = true;
      });

      final voiceService = ChatbotVoiceService();

      final data = await voiceService.sendVoiceMessage(
        audioPath: path,
        userId: "test_user",
        language: "English",
        domain: "agriculture",
        conversationId: currentConversationId,
      );

      print("DATA = $data");
      print("TRANSCRIPT = ${data["transcript"]}");
      print("RESPONSE = ${data["response"]}");

      setState(() {
        messages.add({"text": data["transcript"], "isUser": true});

        messages.add({
          "text": data["response"].replaceAll("**", ""),
          "isUser": false,
        });
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to process voice");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.failLoadConvo,
      );
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
                  return ListTile(
                    title: Text(AppLocalizations.of(context)!.typing),
                  );
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
                  child: isRecording
                      ? Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            isCancelled
                                ? "Recording Cancelled"
                                : "Slide Left to Cancel ⬅️",
                            style: TextStyle(color: Colors.green.shade900),
                          ),
                        )
                      : TextField(
                          controller: _messageController,
                          style: TextStyle(color: Colors.green.shade900),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.askAnything,
                          ),
                        ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send, color: Colors.green.shade900),
                ),

                GestureDetector(
                  onLongPressStart: (_) async {
                    await startRecording();
                  },

                  onLongPressMoveUpdate: (details) {
                    if (details.offsetFromOrigin.dx < -120) {
                      cancelRecording();
                    }
                  },

                  onLongPressEnd: (_) async {
                    await stopRecording();
                  },

                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.mic,
                      size: 28,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
