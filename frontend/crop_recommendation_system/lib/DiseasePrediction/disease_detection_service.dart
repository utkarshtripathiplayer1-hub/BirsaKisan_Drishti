import 'dart:convert';
import 'dart:io';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class DiseaseDetectionService {
  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConfig.baseUrl}/disease/predict"),
    );

    request.headers.addAll({"Authorization": "Bearer $token"});

    // 2. DETECT MIME TYPE (e.g. image/jpeg, image/png)
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeTypeSplit = mimeType.split('/');

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Double-check if server expects 'image' or 'file'
        imageFile.path,
        contentType: http.MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
      ),
    );

    var response = await request.send();

    // 3. READ RESPONSE BODY REGARDLESS OF STATUS CODE
    final responseBody = await response.stream.bytesToString();

    print("Status Code: ${response.statusCode}");
    print("Response Body: $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      // Throw the actual backend message instead of a generic one
      throw Exception(
        "Failed to predict disease ($response.statusCode): $responseBody",
      );
    }
  }
}
