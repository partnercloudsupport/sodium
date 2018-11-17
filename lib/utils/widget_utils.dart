import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
    bgcolor: "#000000",
    textcolor: '#ffffff',
  );
}

Widget shimmer(double width, double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200],
    highlightColor: Colors.grey[50],
    child: Container(
      color: Colors.grey[200],
      height: height,
      width: width,
    ),
  );
}
