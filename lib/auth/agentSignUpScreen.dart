import 'package:animator/animator.dart';
import 'package:safeboxx/auth/agentSignInScreen.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/routes.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(SignUpScreen());
// }


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isInProgress = false;
  bool _isClickonSignIn = false;
  bool _visible = false;
  bool _isPhoneAuthEnable = true;
  bool _isGoogleAuthEnable = false;
  bool _isEmailAuthEnable = false;
  bool _isLoading = false;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _teMobileEmail = TextEditingController();
  final _teCountryCode = TextEditingController();
  final _tePassword = TextEditingController();

  FocusNode _focusNodeMobileEmail = new FocusNode();
  FocusNode _focusNodeCountryCode = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();





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

  final _formKey = new GlobalKey<FormState>();
  String name, email, password, Address, Phone;
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appBarheight,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Animator(
                                tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0.2, 0)),
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
                            !_isClickonSignIn
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _isClickonSignIn = true;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 700));

                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) => SignInScreen(),
                                        ),
                                      )
                                          .then((onValue) {
                                        setState(() {
                                          _isClickonSignIn = false;
                                        });
                                      });
                                    },
                                    child: Animator(
                                      tween: Tween<double>(begin: 0.8, end: 1.1),
                                      curve: Curves.easeInToLinear,
                                      cycles: 0,
                                      builder: (anim) => Transform.scale(
                                        scale: anim.value,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Text(
                                            'Agent Sign In',
                                            style: TextStyle(
                                              color: AllCoustomTheme.getTextThemeColors(),
                                              fontSize: ConstanceData.SIZE_TITLE18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: 14),
                                    child: CupertinoActivityIndicator(
                                      radius: 12,
                                    ),
                                  )
                          ],
                        ),
                        SizedBox(
                          height: 20,
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
                                child: Text(
                                  'Agent Sign Up',
                                  style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _visible
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
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
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2)),
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
                                      Container(
                                        height: 40,
                                        color: AllCoustomTheme.getsecoundTextThemeColor(),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              ConstanceData.userImage,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Select photo',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateName,
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                onChanged: (value) {
                                                  name = value; //get the value entered by user.
                                                },
                                                keyboardType: TextInputType.text,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Enter name here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'Name',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
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
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateEmail,
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                onChanged: (value) {
                                                  email = value; //get the value entered by user.
                                                },
                                                keyboardType: TextInputType.emailAddress,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Enter email here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'E-mail',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
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
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, bottom: 10),
                                              child: TextFormField(
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                onChanged: (value) {
                                                  password = value; //get the value entered by user.
                                                },
                                                keyboardType: TextInputType.text,
                                                obscureText: true,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Enter password here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
                                                  ),
                                                ),
                                                validator: _validatePassword,
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
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, bottom: 10),
                                              child: TextFormField(
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                // onChanged: (value) {
                                                //   password = value; //get the value entered by user.
                                                // },
                                                keyboardType: TextInputType.text,
                                                obscureText: true,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Confirm password here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'Confirm Password',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
                                                  ),
                                                ),
                                                validator: _validatePassword,
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
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateName,
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                onChanged: (value) {
                                                  Address = value; //get the value entered by user.
                                                },
                                                keyboardType: TextInputType.text,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Enter address here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'Address',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
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
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 14, top: 4),
                                              child: TextFormField(
                                                validator: _validateName,
                                                cursorColor: AllCoustomTheme.getTextThemeColors(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ConstanceData.SIZE_TITLE16,
                                                  color: AllCoustomTheme.getTextThemeColors(),
                                                ),
                                                onChanged: (value) {
                                                  Phone = value; //get the value entered by user.
                                                },
                                                keyboardType: TextInputType.phone,
                                                decoration: new InputDecoration(
                                                  focusColor: AllCoustomTheme.getTextThemeColors(),
                                                  fillColor: AllCoustomTheme.getTextThemeColors(),
                                                  hintText: 'Enter Phone Number here...',
                                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: ConstanceData.SIZE_TITLE14),
                                                  labelText: 'Phone Number',
                                                  labelStyle: TextStyle(
                                                    fontSize: ConstanceData.SIZE_TITLE16,
                                                    color: AllCoustomTheme.getTextThemeColors(),
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
                                        height: 8,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20, left: 14, right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[

                                            SizedBox(
                                              height: 50,
                                              child: !_isInProgress
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        _submit();
                                                      },
                                                      child: Animator(
                                                        tween: Tween<double>(begin: 0.8, end: 1.1),
                                                        curve: Curves.easeInToLinear,
                                                        cycles: 0,
                                                        builder: (anim) => Transform.scale(
                                                          scale: anim.value,

                                                          child: Container(

                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                              border: new Border.all(color: Colors.white, width: 1.5),
                                                              shape: BoxShape.circle,
                                                              gradient: LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  globals.buttoncolor1,
                                                                  globals.buttoncolor2,
                                                                ],
                                                              ),
                                                            ),

                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 3),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios,
                                                                size: 20,
                                                                color: AllCoustomTheme.getTextThemeColors(),
                                                              ),
                                                            ),
                                                          ),

                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.only(right: 14),
                                                      child: CupertinoActivityIndicator(
                                                        radius: 12,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _visible
                            ? Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Text(
                                      'Terms & Privacy Policy',
                                      style: TextStyle(
                                        color: AllCoustomTheme.getsecoundTextThemeColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
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
      showProgress = true;
      _isInProgress = true;


    });
    await Future.delayed(const Duration(milliseconds: 700));

    FocusScope.of(context).requestFocus(myScreenFocusNode);
    if (_formKey.currentState.validate() == false) {

      setState(() {
        _isInProgress = false;
        showProgress = false;
      });
      return;
    }

    _formKey.currentState.save();



    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Firestore.instance.collection('Users')


          .add({'email': email, 'password': password, 'address': Address, 'phone number': Phone, 'name': name});


      if (newUser != null) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.Home, (Route<dynamic> route) => false);
        // Navigator.push(context,
        //   MaterialPageRoute(
        //       builder: (context) => MyLoginPage()),
        // );
      }
      setState(() {
        showProgress = false;
      });
    }
    catch (e)
    {
      print(e);
    }


  }

  String _validateName(value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    }
    return null;
  }

  String _validateEmail(value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    } else if (Validators.validateEmail(value) == false) {
      return "Please enter valid email";
    }
    return null;
  }

  String _validatePassword(value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 5) {
      return 'Password must contains ${5} characters';
    } else {
      return null;
    }
  }
}
