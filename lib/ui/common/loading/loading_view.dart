import 'package:flutter/material.dart';
import 'package:sodium/data/model/loading_status.dart';

class LoadingView extends StatelessWidget {
  final LoadingStatus loadingStatus;
  final Widget initialContent;
  final Widget loadingContent;
  final Widget errorContent;
  final Widget successContent;

  LoadingView({
    @required this.loadingStatus,
    @required this.loadingContent,
    @required this.initialContent,
    this.errorContent,
    this.successContent,
  });

  @override
  Widget build(BuildContext context) {
    var content;

    switch (loadingStatus) {
      case LoadingStatus.initial:
        content = initialContent;
        break;
      case LoadingStatus.loading:
        content = loadingContent;
        break;
      case LoadingStatus.success:
        content = successContent ?? initialContent;
        break;
      case LoadingStatus.error:
        content = errorContent ?? initialContent;
        break;
    }

    return content;
  }
}
