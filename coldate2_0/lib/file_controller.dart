import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileController {
  //画像の保存先を取得する
  static Future get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future saveLocalImage(File image) async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    File imageFile = File(imagePath);

    var savedFile = await imageFile.writeAsBytes(await image.readAsBytes());

    return savedFile;
  }

  static Future loadLocalImage() async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    return File(imagePath);
  }

  static void removeImage() async {
    final path = await localPath;
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }
}
