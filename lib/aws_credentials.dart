import 'package:aws_signature_v4/aws_signature_v4.dart';

class MyAWSCredentials {
  static const String accessKey = "AKIAQMEY6D6W64FBWNHU";
  static const String secretKey = "JOYt2NRNCVdfQ/QWCMEGrxlCbs2WAm7t9xohYCQY";
  static const String region = "us-east-1"; // Change based on your AWS region

  // You can create the credentials manually as shown here
  static final credentials = AWSCredentials(
    accessKey,
    secretKey,
  );
}

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'aws_secrets_manager.dart';

// class MyAWSCredentials {
//   static const _storage = FlutterSecureStorage();

//   // Keys for storing credentials in secure storage
//   static const String accessKeyStorageKey = "AWS_ACCESS_KEY";
//   static const String secretKeyStorageKey = "AWS_SECRET_KEY";

//   // Fetch credentials from secure storage
//   static Future<Map<String, String>?> getCredentials() async {
//     String? accessKey = await _storage.read(key: accessKeyStorageKey);
//     String? secretKey = await _storage.read(key: secretKeyStorageKey);

//     if (accessKey != null && secretKey != null) {
//       return {
//         'AWSAccessKeyId': accessKey,
//         'AWSSecretKey': secretKey,
//       };
//     }
//     return null;
//   }

//   // Save credentials to secure storage
//   static Future<void> saveCredentials(Map<String, String> credentials) async {
//     await _storage.write(
//         key: accessKeyStorageKey, value: credentials['AWSAccessKeyId']);
//     await _storage.write(
//         key: secretKeyStorageKey, value: credentials['AWSSecretKey']);
//   }

//   // Fetch credentials, either from secure storage or Secrets Manager
//   static Future<Map<String, String>> fetchCredentials() async {
//     Map<String, String>? credentials = await getCredentials();
//     if (credentials != null) {
//       return credentials; // Return stored credentials if available
//     } else {
//       // Fetch from Secrets Manager and store locally
//       Map<String, String>? fetchedCredentials =
//           await AWSSecretsManager.fetchAWSKeysFromSecretsManager();
//       if (fetchedCredentials != null) {
//         await saveCredentials(fetchedCredentials); // Save to local storage
//         return fetchedCredentials;
//       } else {
//         throw Exception("Failed to fetch AWS credentials.");
//       }
//     }
//   }
// }
