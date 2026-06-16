import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DiseaseDetectionService {
  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',

      // PUT TANISHA'S URL HERE
      Uri.parse(
        "https://remedy-factsheet-empirical.ngrok-free.dev/disease/predict",
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
