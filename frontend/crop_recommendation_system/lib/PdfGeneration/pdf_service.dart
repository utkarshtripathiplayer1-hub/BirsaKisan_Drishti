import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class PdfService {
  static Future<File> downloadPdf(String recommendationId) async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/pdf/generate/$recommendationId',
      ),
    );

    print('Status Code: ${response.statusCode}');
    print('Content Type: ${response.headers['content-type']}');

    if (response.statusCode != 200) {
      throw Exception('Failed to generate PDF');
    }

    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/report.pdf',
    );

    await file.writeAsBytes(
      response.bodyBytes,
    );

    return file;
  }
}