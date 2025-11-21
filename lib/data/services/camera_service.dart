import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera({int imageQuality = 80}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    if (image == null) return null;
    return File(image.path);
  }

  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    return recognizedText.text;
  }
}
