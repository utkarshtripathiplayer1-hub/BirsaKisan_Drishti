import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class DiseaseDetectionService {
  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',

      // PUT TANISHA'S URL HERE
      Uri.parse(
        "${ApiConfig.baseUrl}/disease/predict",
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // keep same as backend
        imageFile.path,
      ),
    );

    var response = await request.send();
    print(response);

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();

      return jsonDecode(responseBody);
    } else {
      throw Exception("Failed to predict disease");
    }
  }
}
