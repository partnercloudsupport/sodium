import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';

class OrganizationItem extends StatelessWidget {
  final String nameThai;
  final String nameEnglish;
  final String imageAsset;

  OrganizationItem({
    Key key,
    @required this.nameThai,
    @required this.nameEnglish,
    @required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.asset(
          imageAsset,
          width: 70.0,
        ),
        SizedBox(width: 14.0),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                nameThai,
                textAlign: TextAlign.left,
                style: Style.tileTitle,
              ),
              Text(
                nameEnglish.toUpperCase(),
                textAlign: TextAlign.left,
                style: Style.description,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
