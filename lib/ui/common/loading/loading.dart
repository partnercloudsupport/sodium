import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String title;

  Loading({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
