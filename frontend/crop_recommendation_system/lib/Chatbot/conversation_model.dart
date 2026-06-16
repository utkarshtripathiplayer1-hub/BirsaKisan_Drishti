class ConversationModel {
  final String conversationId;
  final String title;
  final String domain;
  final String language;
  final String updatedAt;

  ConversationModel({
    required this.conversationId,
    required this.title,
    required this.domain,
    required this.language,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json["conversation_id"],
      title: json["title"],
      domain: json["domain"],
      language: json["language"],
      updatedAt: json["updated_at"],
    );
  }
}