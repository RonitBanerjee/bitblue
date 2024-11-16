// import 'package:http/http.dart' as http;

// class Functions {
//    Future<void> checkForUpdate({String currentVersion}) async {
//     try {
//       final response = await http.get(Uri.parse(updateUrl));
//       if (response.statusCode == 200) {
//         final versionData = json.decode(response.body);
//         if (versionData['latest_version'] != currentVersion) {
//           return versionData;
//         }
//       }
//     } catch (e) {
//       print("Error checking for updates: $e");
//     }
//   }
// }