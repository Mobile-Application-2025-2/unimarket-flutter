import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
}


