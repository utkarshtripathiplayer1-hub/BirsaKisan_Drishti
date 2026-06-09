import 'dart:convert';
import 'package:http/http.dart' as http;


class CropRecommendService {

  static const String apiUrl = 'https://remedy-factsheet-empirical.ngrok-free.dev/crop/recommend';

  Future<Map<String, dynamic>> getRecommendation({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double soilMoisture,
    required double temperature,
    required double humidity,
    required double rainfall,
    required double solarRadiation,
    required double elevation,
    required String irrigation,
    required String previousCrop,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "N": n,
        "P": p,
        "K": k,
        "pH": ph,
        "soil_moisture": soilMoisture,
        "temperature": temperature,
        "humidity": humidity,
        "rainfall": rainfall,
        "solar_radiation": solarRadiation,
        "elevation": elevation,
        "irrigation": irrigation,
        "previous_crop": previousCrop,
      }),
    );

    // print("Status Code: ${response.statusCode}");
    // print("Response Body:");
    // print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }
}
