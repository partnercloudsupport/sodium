import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String title;
  final double percent;

  ProgressDialog({
    this.title,
    this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      children: <Widget>[
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text(title),
            Text('$percent %'),
          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
