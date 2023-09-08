import 'dart:convert';
import 'dart:io';

class FileHelper {

  static imageToBase65(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();

    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }
}