import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
  }

  Future<String> _getLocalFilePath() async {
    final directory = await getExternalStorageDirectory();
    return "${directory!.path}/app_version2.apk";
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

  Future<void> _downloadAndInstallApk(String apkUrl) async {
    final dio = Dio();
    final apkPath = await _getLocalFilePath();

    try {
      await dio.download(apkUrl, apkPath);
      OpenFile.open(apkPath);
    } catch (e) {
      print("Error downloading APK: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            'https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExMXhpcHgxdDRzZTk4MDU3cGZteWlkYnlwaG95dWNkNjRiZnM3azkzMCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/clnORRzuaBV7rNisCP/giphy.gif',
          ),
          const Text(
            'This is the latest version of BitBlue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'v2.0.0',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _checkForUpdate();
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
