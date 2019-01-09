import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/utils/widget_utils.dart';

Completer<Null> loadingCompleter(
  BuildContext context, [
  String loadingTitle = 'กำลังโหลด',
  String successMessage = 'สำเร็จ',
  String errorMessage = 'ล้มเหลว',
]) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => LoadingDialog(title: loadingTitle),
  );

  final Completer<Null> completer = Completer<Null>();

  completer.future.then((_) {
    popLoading(context); // Hide loading
    showToast(successMessage);
  }).catchError((error) {
    popLoading(context); // Hide loading
    showToast(errorMessage);
  });

  return completer;
}

Completer<Null> loadingThenPushReplaceCompleter(
  BuildContext context,
  String route, [
  String loadingTitle = 'กำลังโหลด',
  String successMessage = 'สำเร็จ',
  String errorMessage = 'ล้มเหลว',
]) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => LoadingDialog(title: loadingTitle),
  );

  final Completer<Null> completer = Completer<Null>();

  completer.future.then((_) {
    showToast(successMessage);
    popLoading(context);

    Navigator.of(context).pushReplacementNamed(route);
  }).catchError((error) {
    showToast(errorMessage);
    popLoading(context);
  });

  return completer;
}

Completer<Null> loadingThenPopCompleter(
  BuildContext context, [
  String loadingTitle = 'กำลังโหลด',
  String successMessage = 'สำเร็จ',
  String errorMessage = 'ล้มเหลว',
]) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => LoadingDialog(title: loadingTitle),
  );

  final Completer<Null> completer = Completer<Null>();

  completer.future.then((_) {
    showToast(successMessage);
    popLoading(context);
    popScreen(context);
  }).catchError((error) {
    showToast(errorMessage);
    popLoading(context);
  });

  return completer;
}
