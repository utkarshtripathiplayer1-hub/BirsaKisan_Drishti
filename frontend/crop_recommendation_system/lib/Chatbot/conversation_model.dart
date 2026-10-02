class ConversationModel {
  final String conversationId;
  final String title;
  final String createdAt;
  final String updatedAt;

  ConversationModel({
    required this.conversationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json["id"].toString(),
      title: json["title"].toString(),
      createdAt: json["created_at"].toString(),
      updatedAt: json["updated_at"].toString(),
    );
  }
}
