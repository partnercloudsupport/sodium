import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color highlightColor;

  RippleButton({
    this.onPress,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.highlightColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: backgroundColor,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: highlightColor,
          onTap: onPress,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(text, style: TextStyle(color: textColor)),
            ),
          ),
        ),
      ),
    );
  }
}
