import 'package:bitblue/api/functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  void _downloadAndInstallApk(String apkUrl) async {
    await Functions.requestPermissions();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Close the loading indicator
      Navigator.pop(context);

      // Open the downloaded APK file
      launchUrl(Uri.parse(apkUrl));
    } catch (e) {
      Navigator.pop(context);
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
          Text(
            'v${Functions.currentVersion}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                var versionData = await Functions.checkForUpdate();
                if (versionData['latest_version'] != Functions.currentVersion) {
                  _showUpdateDialog(versionData['apk_url']);
                } else {
                  _showNoUpdatesDialog();
                }
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

  //This is the code for the dialog
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

  void _showNoUpdatesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Already At Latest Version"),
          content:
              Text("You aleady have the latest version of this app installed!"),
        );
      },
    );
  }
}
