import 'package:flutter/material.dart';

class IconMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const IconMessage({
    this.icon,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 64.0),
          SizedBox(height: 20.0),
          Text(
            '$title',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '$description',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
