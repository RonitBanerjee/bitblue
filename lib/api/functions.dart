import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Functions {
  static String currentVersion = "1.0.0";
  static String updateUrl =
      "https://demo-uxapollo.s3.eu-north-1.amazonaws.com/bitblue.json";

  static Future<dynamic> checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse(updateUrl));
      if (response.statusCode == 200) {
        final versionData = json.decode(response.body);
          return versionData;
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }
}
