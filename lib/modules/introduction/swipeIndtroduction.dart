import 'dart:math';

import 'package:animator/animator.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/routes.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class SwipeIntroductionScreen extends StatefulWidget {
  @override
  _SwipeIntroductionScreenState createState() =>
      _SwipeIntroductionScreenState();
}

class _SwipeIntroductionScreenState extends State<SwipeIntroductionScreen>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  bool loop = false;
  bool _isInProgress = false;

  // PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;

  AnimationController controller;
  Animation<Offset> offset;

  PageController pageController;

  @override
  void initState() {
    super.initState();
    animation();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.4))
        .animate(controller);

    controller.forward();

    pageController = new PageController();
  }

  double size = 10.0;
  double activeSize = 10.0;

  animation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var children = <Widget>[
      Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: height / 1.7,
                    width: width / 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          globals.buttoncolor1,
                          globals.buttoncolor2,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Animator(
                tween: Tween<double>(begin: 0, end: 0),
                duration: Duration(milliseconds: 500),
                repeats: 1,
                builder: (anim) => Transform(
                  transform: Matrix4.rotationZ(anim.value),
                  alignment: Alignment.center,
                  child: Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        ConstanceData.planetImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 2,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  globals.buttoncolor1,
                  globals.buttoncolor2,
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: _visible ? 1.0 : 0.0,
            child: Text(
              'Safe boxx',
              style: TextStyle(
                color: AllCoustomTheme.getTextThemeColors(),
                fontSize: ConstanceData.SIZE_TITLE25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SlideTransition(
            position: offset,
            child: Text(
              'Our platform helps you to save for the future \nWith us, the future is protected.\nsave now and be happy you did',
              style: TextStyle(
                color: AllCoustomTheme.getsecoundTextThemeColor(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      Container(
        height: height,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        height: height / 1.7,
                        width: width / 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              globals.buttoncolor1,
                              globals.buttoncolor2,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    ];

    return Stack(
      children: <Widget>[
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor(globals.primaryColorString).withOpacity(0.6),
                HexColor(globals.primaryColorString).withOpacity(0.6),
                HexColor(globals.primaryColorString).withOpacity(0.6),
                HexColor(globals.primaryColorString).withOpacity(0.6),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    PageView(
                      controller: pageController,
                      children: children,
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(bottom: 20.0),
                    //     child: PageIndicator(
                    //       layout: layout,
                    //       size: size,
                    //       activeSize: activeSize,
                    //       controller: pageController,
                    //       space: 5.0,
                    //       count: 2,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
