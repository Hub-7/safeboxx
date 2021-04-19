import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeboxx/auth/signInScreen.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:safeboxx/flutter_paystack.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String username, String email, String password);
  Future<void> signOut();
}
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signUp(String username, String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)) as FirebaseUser;
    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }

  @override
  Future<String> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }}
class AccountDetailsScreen extends StatefulWidget {
  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _isInProgress = false;
  bool _visible = false;

  animation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _visible = true;
    });
  }



  @override
  void initState() {

    super.initState();
    animation();
  }




  String backendUrl = '{YOUR_BACKEND_URL}';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
  String paystackPublicKey = '{YOUR_PAYSTACK_PUBLIC_KEY}';
  static const String appName = 'Paystack Example';



  final _formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double appBarheight = appBar.preferredSize.height;
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
          body: ModalProgressHUD(
            inAsyncCall: _isInProgress,
            opacity: 0,
            progressIndicator: SizedBox(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: appBarheight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Animator(
                                tween: Tween<Offset>(
                                    begin: Offset(0, 0), end: Offset(0.2, 0)),
                                duration: Duration(milliseconds: 500),
                                cycles: 0,
                                builder: (anim) => FractionalTranslation(
                                  translation: anim.value,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: <Widget>[
                          Animator(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 500),
                            cycles: 1,
                            builder: (anim) => SizeTransition(
                              sizeFactor: anim,
                              axis: Axis.horizontal,
                              axisAlignment: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Bank Account Details',
                                  style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: _visible
                            ? Container(
                                padding: EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20)),
                                  color: AllCoustomTheme.boxColor(),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 0.5,
                                      ),
                                      Container(
                                        height: 5,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(2)),
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
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateAccName,
                                                cursorColor: AllCoustomTheme
                                                    .getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE16,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  fillColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  hintText:
                                                      'Enter account name here...',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: ConstanceData
                                                          .SIZE_TITLE14),
                                                  labelText: 'Account Name',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE16,
                                                    color: AllCoustomTheme
                                                        .getTextThemeColors(),
                                                  ),
                                                ),
                                                //controller: lastnameController,
                                                onSaved: (value) {
                                                  setState(() {
                                                    //lastnamesearchText = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateAccNumber,
                                                cursorColor: AllCoustomTheme
                                                    .getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE16,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  fillColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  hintText:
                                                  'Enter account number here...',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: ConstanceData
                                                          .SIZE_TITLE14),
                                                  labelText: 'Account Number',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE16,
                                                    color: AllCoustomTheme
                                                        .getTextThemeColors(),
                                                  ),
                                                ),
                                                //controller: lastnameController,
                                                onSaved: (value) {
                                                  setState(() {
                                                    //lastnamesearchText = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateBank,
                                                cursorColor: AllCoustomTheme
                                                    .getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE16,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                                keyboardType:
                                                TextInputType.text,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  fillColor: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                  hintText:
                                                  'Select Bank',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: ConstanceData
                                                          .SIZE_TITLE14),
                                                  labelText: 'Bank Name',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE16,
                                                    color: AllCoustomTheme
                                                        .getTextThemeColors(),
                                                  ),
                                                ),
                                                //controller: lastnameController,
                                                onSaved: (value) {
                                                  setState(() {
                                                    //lastnamesearchText = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      !_isInProgress
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, left: 10, top: 20),
                                              child: FlatButton(
                                                padding: EdgeInsets.all(0),
                                                child: new Container(
                                                  height: 45.0,
                                                  alignment:
                                                      FractionalOffset.center,
                                                  decoration: BoxDecoration(
                                                    border: new Border.all(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        globals.buttoncolor1,
                                                        globals.buttoncolor2,
                                                      ],
                                                    ),
                                                  ),
                                                  child: new Text(
                                                    "Update",
                                                    style: new TextStyle(
                                                      color: AllCoustomTheme
                                                          .getReBlackAndWhiteThemeColors(),
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _submit();
                                                },
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 44),
                                              child: CupertinoActivityIndicator(
                                                radius: 12,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  var myScreenFocusNode = FocusNode();

  _submit() async {
    setState(() {
      _isInProgress = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));

    FocusScope.of(context).requestFocus(myScreenFocusNode);
    if (_formKey.currentState.validate() == false) {
      setState(() {
        _isInProgress = false;
      });
      return;
    }
    _formKey.currentState.save();

    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context)
        .push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => SignInScreen(),
      ),
    )
        .then((onValue) {
      setState(() {
        _isInProgress = false;
      });
    });
  }

  String _validateAccName(value) {
    if (value.isEmpty) {
      return "Account Name cannot be empty";
    }
    // else if (Validators.validateEmail(value) == false) {
    //   return "Please enter valid email";
    // }
    return null;
  }
  String _validateAccNumber(value) {
    if (value.isEmpty) {
      return "Account Number cannot be empty";
    }
    // else if (Validators.validateEmail(value) == false) {
    //   return "Please enter valid email";
    // }
    return null;
  }
  String _validateBank(value) {
    if (value.isEmpty) {
      return "Select Bank";
    }
    // else if (Validators.validateEmail(value) == false) {
    //   return "Please enter valid email";
    // }
    return null;
  }
}

class Validators {
  static const Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp _regex = new RegExp(_pattern);

  static bool validateEmail(String value) {
    return _regex.hasMatch(value);
  }
}
