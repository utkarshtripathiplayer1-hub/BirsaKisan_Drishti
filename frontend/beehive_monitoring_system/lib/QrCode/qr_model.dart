import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_BEEHIVE_URL']!;
}

class QrItem {
  final String hiveId;
  final String hiveName;
  final String token;
  final String generatedAt;
  final String imageUrl;

  QrItem({
    required this.hiveId,
    required this.hiveName,
    required this.token,
    required this.generatedAt,
    required this.imageUrl,
  });

  factory QrItem.fromJson(Map<String, dynamic> json) {
    return QrItem(
      hiveId: json['hive_id'],
      hiveName: json['hive_name'],
      token: json['token'],
      generatedAt: json['generated_at'],
      imageUrl: json['image_url'],
    );
  }

  String get fullImageUrl {
    return '${ApiConfig.baseUrl}$imageUrl';
  }
}

class QrGenerationResponse {
  final int generated;
  final int total;
  final List<QrItem> items;

  QrGenerationResponse({
    required this.generated,
    required this.total,
    required this.items,
  });

  factory QrGenerationResponse.fromJson(Map<String, dynamic> json) {
    return QrGenerationResponse(
      generated: json['generated'],
      total: json['total'],
      items: (json['items'] as List)
          .map((item) => QrItem.fromJson(item))
          .toList(),
    );
  }
}
