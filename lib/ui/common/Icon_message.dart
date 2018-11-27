import 'package:flutter/material.dart';

class IconMessage extends StatelessWidget {
  final Icon icon;
  final Text title;
  final Text description;

  const IconMessage({
    @required this.icon,
    @required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          SizedBox(height: 20.0),
          title,
          description != null ? description : Container(),
        ],
      ),
    );
  }
}
