import 'dart:convert';
import 'package:http/http.dart' as http;

class FaceRecognitionRepository {
  final String _awsLambdaUrl =
      "https://yyuc0r8x6l.execute-api.us-east-1.amazonaws.com/FaceMatchingLambda";

  Future<bool> compareFacesAWS(String sourceImage, String targetImage) async {
    final Uri lambdaUrl = Uri.parse(_awsLambdaUrl);

    final Map<String, dynamic> requestBody = {
      "sourceImage": sourceImage,
      "targetImage": targetImage
    };

    try {
      final response = await http.post(
        lambdaUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("AWS Rekognition Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey("message")) {
          return Future.error(
              jsonResponse["message"]); // ✅ Throws error instead of handling UI
        }

        return jsonResponse["match"] ?? false;
      } else {
        print("Error comparing faces: ${response.body}");
        return Future.error("Face comparison failed!");
      }
    } catch (e) {
      print("Exception: $e");
      return Future.error("Error: $e");
    }
  }
}
