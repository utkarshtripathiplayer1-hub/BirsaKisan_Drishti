import 'package:crop_recommendation_system/Chatbot/chat_message_model.dart';
import 'package:crop_recommendation_system/Chatbot/chatbot_service.dart';
import 'package:get/get.dart';

class ChatbotController extends GetxController {

  final ChatbotService service =
      ChatbotService();

  RxList<ChatMessageModel> messages =
      <ChatMessageModel>[].obs;

  RxBool isLoading = false.obs;

  String? conversationId;
}