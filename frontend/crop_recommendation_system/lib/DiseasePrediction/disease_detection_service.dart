import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DiseaseDetectionService {

  Future<Map<String, dynamic>> predictDisease(
      File imageFile) async {

    var request = http.MultipartRequest(
      'POST',

      // PUT TANISHA'S URL HERE
      Uri.parse(
          "https://remedy-factsheet-empirical.ngrok-free.dev/helloChangeMe"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // keep same as backend
        imageFile.path,
      ),
    );

    var response =
        await request.send();

    if (response.statusCode == 200) {

      var responseBody =
          await response.stream.bytesToString();

      return jsonDecode(
          responseBody);

    } else {

      throw Exception(
          "Failed to predict disease");
    }
  }
}