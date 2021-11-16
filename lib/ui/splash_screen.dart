import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    const _colorizeColors = [
      Colors.orange,
      Colors.cyan,
      Colors.orangeAccent,
      Colors.yellow,
    ];
    return Scaffold(
        body: Center(
      child: SlideInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 100, bottom: 30, left: 30, right: 30),
                child: Image.asset(
                  "assets/images/logo.png",
                  scale: isLandscape ? 5 : 3,
                ),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Hexabitz Modules App',
                        speed: const Duration(milliseconds: 500),
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Horizon',
                        ),
                        colors: _colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
