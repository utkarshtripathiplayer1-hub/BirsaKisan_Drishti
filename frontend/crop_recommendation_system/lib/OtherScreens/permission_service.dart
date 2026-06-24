import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestAllPermissions() async {
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }

    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }

    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }
  }
}