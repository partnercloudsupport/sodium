import 'dart:async';
import 'dart:io';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

Future<File> resizeImage(File file, [int width = 480]) async {
  final image = decodeImage(file.readAsBytesSync());
  final resizedImage = copyResize(image, width);
  final tempDir = await getTemporaryDirectory();

  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final resizedFile = File('${tempDir.path}/$fileName.jpg')..writeAsBytesSync(encodeJpg(resizedImage));

  return resizedFile;
}
