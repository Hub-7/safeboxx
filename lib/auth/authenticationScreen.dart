import 'package:animator/animator.dart';
import 'package:safeboxx/auth/signInScreen.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:gradient_text/gradient_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'agentSelectAuthScreen.dart';
import 'selectAuthScreen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _visible = false;
  bool _visiblesignUpbutton = false;
  bool _isInProgress = false;

  animationText() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _visible = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _visiblesignUpbutton = true;
    });
  }

  @override
  void initState() {
    super.initState();
    animationText();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor(globals.primaryColorString).withOpacity(0.9),
                HexColor(globals.primaryColorString).withOpacity(0.8),
                HexColor(globals.primaryColorString).withOpacity(0.7),
                HexColor(globals.primaryColorString).withOpacity(0.6),
              ],
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              ConstanceData.authImage,
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: _isInProgress,
            opacity: 0,
            progressIndicator: SizedBox(),
            child: Padding(
              padding: EdgeInsets.only(right: 16, bottom: 20, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _visible ? 1.0 : 0.0,
                    child: Center(

                    child: Text(
                      'SafeBoxx',
                      style: TextStyle(
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontSize: ConstanceData.SIZE_TITLE25,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _visible ? 1.0 : 0.0,
                    child: Text(
                      'Our platform helps you to save for the future. \nWith us, the future is protected.\nSave now and be happy you did',
                      style: TextStyle(
                        color: AllCoustomTheme.getTextThemeColors(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _visible
                      ? AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _visiblesignUpbutton ? 1.0 : 0.0,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              height: 45.0,
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    globals.buttoncolor1,
                                    globals.buttoncolor2,
                                  ],
                                )
                              ),
                              child: Text(
                                "Continue as User",
                                style: TextStyle(
                                  color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isInProgress = true;
                              });
                              await Future.delayed(const Duration(milliseconds: 500));
                              Navigator.of(context)
                                  .push(
                                CupertinoPageRoute<void>(
                                  builder: (BuildContext context) => SelectAuthScreen(),
                                ),
                              )
                                  .then((onValue) {
                                setState(() {
                                  _isInProgress = false;
                                });
                              });
                            },
                          ),
                        )
                      : SizedBox(
                          height: 48,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  _visible
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Agents Only',
                              style: TextStyle(
                                color: AllCoustomTheme.getTextThemeColors(),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  _visible
                      ? AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _visiblesignUpbutton ? 1.0 : 0.0,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: new Container(
                              height: 45.0,
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(30),
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                              child: GradientText(
                                "Continue as Agent",
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    globals.buttoncolor1,
                                    globals.buttoncolor2,
                                  ],
                                ),
                                style: new TextStyle(
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isInProgress = true;
                              });
                              await Future.delayed(const Duration(milliseconds: 500));
                              Navigator.of(context)
                                  .push(
                                CupertinoPageRoute<void>(
                                  builder: (BuildContext context) => AgentSelectAuthScreen(),
                                ),
                              )
                                  .then((onValue) {
                                setState(() {
                                  _isInProgress = false;
                                });
                              });
                            },
                          ),
                        )
                      : SizedBox(
                          height: 48,
                        ),
                  SizedBox(
                    height: 4,
                  ),

                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
