import 'crop_rotation_service.dart';

class CropRotationController {

  final CropRotationService _service = CropRotationService();

  Future<Map<String, dynamic>> getCropRotation(
      String recommendationId) async {

    return await _service.getCropRotation(recommendationId);
  }
}