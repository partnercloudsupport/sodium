import 'package:flutter/material.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/screen/about/organization_item.dart';

class AboutScreen extends StatefulWidget {
  static final String route = '/about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('เกี่ยวกับ'),
          elevation: 0.3,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  AssetIcon.salt,
                  color: Theme.of(context).primaryColor,
                  size: 60.0,
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mind Sodium',
                      textAlign: TextAlign.center,
                      style: Style.titlePrimary,
                    ),
                    Text(
                      'ลดทานเค็มเพื่อสุขภาพที่ดี',
                      textAlign: TextAlign.center,
                      style: Style.description,
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'โดยความร่วมมือจาก',
                      textAlign: TextAlign.center,
                      style: Style.title,
                    ),
                    SizedBox(height: 16.0),
                    OrganizationItem(
                      nameThai: 'วิทยาลัยศิลปะสื่อและเทคโนโลยี',
                      nameEnglish: 'College of Arts, Media and Technology',
                      imageAsset: AssetImages.logoCamt,
                    ),
                    SizedBox(height: 16.0),
                    OrganizationItem(
                      nameThai: 'คณะพยาบาลศาสตร์',
                      nameEnglish: 'Faculty of Nursing',
                      imageAsset: AssetImages.logoCmu,
                    ),
                    SizedBox(height: 16.0),
                    OrganizationItem(
                      nameThai: 'มหาวิทยาลัยเชียงใหม่',
                      nameEnglish: 'Chiang Mai University',
                      imageAsset: AssetImages.logoNursing,
                    ),
                    SizedBox(height: 16.0),
                    OrganizationItem(
                      nameThai: 'สำนักงานคณะกรรมการวิจัยแห่งชาติ',
                      nameEnglish: 'national research council of thailand',
                      imageAsset: AssetImages.logoNrct,
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'พัฒนาโดย',
                      textAlign: TextAlign.center,
                      style: Style.title,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Embedded System & Mobile Application Laboratory',
                      style: Style.description,
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
