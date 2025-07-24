import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.request();
  var manage = await Permission.manageExternalStorage.request();
  return status.isGranted && manage.isGranted;
}
