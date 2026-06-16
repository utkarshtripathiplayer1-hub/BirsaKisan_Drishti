import 'crop_recommend_service.dart';

class CropRecommendController {

  final CropRecommendService _service =
      CropRecommendService();

  Future<Map<String, dynamic>> recommendCrop({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double soilMoisture,
    required double temperature,
    required double humidity,
    required double rainfall,
    required String soilType,
  }) async {

    return await _service.getRecommendation(
      n: n,
      p: p,
      k: k,
      ph: ph,
      soilMoisture: soilMoisture,
      temperature: temperature,
      humidity: humidity,
      rainfall: rainfall,
      soilType: soilType,
    );
  }
}