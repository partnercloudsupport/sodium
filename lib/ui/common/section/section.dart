import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final Widget title;
  final Widget body;

  SectionContainer({
    this.title,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title,
          SizedBox(height: 8.0),
          body,
        ],
      ),
    );
  }
}
