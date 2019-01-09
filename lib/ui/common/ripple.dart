import 'package:flutter/material.dart';

class RippleContainer extends StatelessWidget {
  RippleContainer({
    this.child,
    this.onPressed,
    this.backgroundColor,
    this.splashColor,
    this.highlightColor,
    this.margin,
    this.padding,
    this.onLongPressed,
  });

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final Function onPressed;
  final Function onLongPressed;

  final Color backgroundColor;
  final Color splashColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      child: InkWell(
        onLongPress: onLongPressed,
        highlightColor: highlightColor ?? Colors.grey.shade300,
        splashColor: splashColor ?? Colors.grey.shade300,
        onTap: () => onPressed(),
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
