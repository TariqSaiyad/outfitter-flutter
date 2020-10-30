import 'dart:io';

class Helper {
  /// Get the current timestamp in milliseconds.
  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// Delete the specified file from the device.
  static Future<bool> deleteFile(String path) async {
    if (path == null) {
      print("PATH is null");
      return false;
    }
    try {
      final file = File(path);
      await file.delete();
      print("File DELETED");
      return true;
    } catch (e) {
      print("FILE NOT DELETED");
      return false;
    }
  }
}
