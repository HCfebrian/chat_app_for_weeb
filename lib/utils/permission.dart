import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> getPermission() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
