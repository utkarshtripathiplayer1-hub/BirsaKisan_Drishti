import 'package:crop_recommendation_system/Profile/profile_model.dart';
import 'package:crop_recommendation_system/Profile/profile_service.dart';

class CropProfileController {
  CropProfile? profile;

  String? error;

  Future<void> fetchProfile() async {
    try {
      error = null;
      profile = await CropProfileService.getProfile();
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  Future<void> updateProfile(CropProfile profile) async {
    try {
      error = null;

      await CropProfileService.updateProfile(profile);
    } catch (e) {
      error = e.toString();

      rethrow;
    }
  }
}
