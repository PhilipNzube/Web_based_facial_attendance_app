import 'package:flutter/material.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../data/repositories/face_recognition_repository.dart';

class FaceRecognitionController extends ChangeNotifier {
  final FaceRecognitionRepository _repository;
  bool isLoading = false;

  FaceRecognitionController(this._repository);

  Future<void> compareFaces(
      BuildContext context, String sourceImage, String targetImage) async {
    isLoading = true;
    notifyListeners();

    try {
      bool isMatch =
          await _repository.compareFacesAWS(sourceImage, targetImage);
      CustomSnackbar.show(
          context, isMatch ? "Faces Match!" : "Faces Do Not Match",
          isError: !isMatch);
    } catch (e) {
      CustomSnackbar.show(context, e.toString(), isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
