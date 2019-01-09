import 'package:flutter/material.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/screen/main/screen.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SplashScreen extends StatefulWidget {
  static final String route = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(duration: Duration(seconds: 5), vsync: this)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacementNamed(MainScreen.route);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mind Sodium',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'ลดทานเค็มเพื่อสุขภาพที่ดี',
                    textAlign: TextAlign.center,
                    style: Style.description.copyWith(
                      fontSize: 20.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  'โดยความร่วมมือจาก',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(AssetImages.logoCamt, width: 75.0),
                    Image.asset(AssetImages.logoCmu, width: 85.0),
                    Image.asset(AssetImages.logoNursing, width: 70.0),
                    Image.asset(AssetImages.logoNrct, width: 70.0),
                  ],
                ),
              ],
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: 80.0,
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: [
                        Theme.of(context).primaryColor,
                        Color(0xFF00A765),
                        Color(0xFF45D99F),
                        Color(0xFFA2ECCF),
                      ],
                      durations: [
                        32000,
                        21000,
                        18000,
                        5000,
                      ],
                      heightPercentages: [
                        0.18,
                        0.26,
                        0.28,
                        0.40,
                      ],
                      blur: MaskFilter.blur(BlurStyle.solid, 5),
                    ),
                    size: Size(double.infinity, double.infinity),
                    waveAmplitude: 0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
