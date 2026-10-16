import 'dart:io';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class PdfService {
  static Future<File> downloadPdf(String recommendationId) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/pdf/generate/$recommendationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Content Type: ${response.headers['content-type']}');

    if (response.statusCode != 200) {
      throw Exception('Failed to generate PDF');
    }

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/report.pdf');

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}
