import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AWSSecretsManager {
  static const String secretName = 'aws/credentials'; // Secret name in AWS

  // Fetch AWS keys from Secrets Manager
  static Future<Map<String, String>?> fetchAWSKeysFromSecretsManager() async {
    final url = Uri.parse(
        'https://secretsmanager.us-east-1.amazonaws.com/'); // AWS Secrets Manager endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'Action': 'GetSecretValue',
          'SecretId': secretName,
        }),
      );

      // Log response status and body
      print('AWS Secrets Manager Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Check if 'SecretString' exists
        if (responseBody.containsKey('SecretString')) {
          final secretString = responseBody['SecretString'];

          // Convert the JSON string into a Map
          Map<String, String> credentials = json.decode(secretString);
          print(
              'AWS Credentials Retrieved: $credentials'); // Log the credentials

          return credentials;
        } else {
          print('Error: SecretString not found in the response.');
        }
      } else {
        print(
            'Error: Failed to fetch AWS credentials. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching AWS credentials: $e');
    }

    return null; // Return null if anything fails
  }
}
