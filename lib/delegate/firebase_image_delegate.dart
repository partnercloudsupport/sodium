import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/utils/file_util.dart';
import 'package:zefyr/zefyr.dart';

class FirebaseImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final Function onCompleteUpload;
  final Function(Stream<StorageTaskEvent>) onStartUploading;

  FirebaseImageDelegate({
    this.onCompleteUpload,
    this.onStartUploading,
  });

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);

    if (file == null) return null;

    try {
      final resizedFile = await resizeImage(file);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
      final task = ref.putFile(resizedFile);

      onStartUploading(task.events);
      await task.onComplete;
      onCompleteUpload();

      return await task.lastSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String imageSource) {
    return CachedNetworkImage(
      imageUrl: imageSource,
      placeholder: ShimmerLoading.square(),
    );
  }
}
