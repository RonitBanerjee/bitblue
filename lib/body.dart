import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:install_plugin/install_plugin.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final String currentVersion = "1.0.0";
  final String updateUrl =
      "https://demo-uxapollo.s3.eu-north-1.amazonaws.com/bitblue.json";

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<String> _getLocalFilePath() async {
    final directory = await getExternalStorageDirectory();
    return "${directory!.path}/app-release.apk";
  }

  Future<void> _requestPermissions() async {
  await Permission.storage.request();
}

  Future<void> _checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse(updateUrl));
      if (response.statusCode == 200) {
        final versionData = json.decode(response.body);
        if (versionData['latest_version'] != currentVersion) {
          print(versionData['apk_url']);
          _showUpdateDialog(versionData['apk_url']);
        }
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }

  void _showUpdateDialog(String apkUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Available"),
          content: const Text(
              "A newer version of the app is available. Do you want to update?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Later"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _downloadAndInstallApk(apkUrl);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _downloadAndInstallApk(String apkUrl) async {
    await _requestPermissions();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Get the path to save the downloaded APK
      String filePath = await _getLocalFilePath();

      // Download the APK using Dio
      Dio dio = Dio();
      await dio.download(apkUrl, filePath);

      // Close the loading indicator
      Navigator.pop(context);

      // Open the downloaded APK file
      launchUrl(Uri.parse(apkUrl));
    } catch (e) {
      Navigator.pop(context); // Close the loading indicator if there's an error
      print("Error downloading or opening APK: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'This is the base version of BitBlue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
           Text(
            'v$currentVersion',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                print('This is here...');
                await _checkForUpdate();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('Check For Updates'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
