import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    this.title,
    this.description,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.left,
                style: Style.titlePrimary,
              ),
              SizedBox(height: 12.0),
              Text(
                widget.description,
                style: Style.description,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: widget.onCancel,
                    child: Text(widget.cancelText, style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  FlatButton(
                    onPressed: widget.onConfirm,
                    child: Text(widget.confirmText, style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
