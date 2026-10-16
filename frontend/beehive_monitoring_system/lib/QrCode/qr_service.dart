import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_BEEHIVE_URL']!;
}

class QrService {

  static Future<http.Response> generateApiaryQrs({
    required String apiaryId,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/qr/apiaries/$apiaryId/generate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("QR API Status Code: ${response.statusCode}");
    print("QR API Response Body:");
    print(response.body);

    return response;
  }
}
