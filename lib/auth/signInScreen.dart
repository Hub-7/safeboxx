import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeboxx/auth/forgotPasswordScreen.dart';
import 'package:safeboxx/auth/phoneLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/routes.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_text/gradient_text.dart';



import 'dart:ui';

import 'package:flutter/services.dart';

import 'package:safeboxx/modules/home/homeScreen.dart';
import 'package:safeboxx/utils/routeNames.dart';
import 'package:safeboxx/utils/util.dart';
import 'package:safeboxx/utils/view_state.dart';
import 'package:safeboxx/stores/login_store.dart';

import 'package:google_sign_in/google_sign_in.dart';



import '../imports.dart';
import 'login_page.dart';
import 'signUpScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
String getURL=null;
class _SignInScreenState extends State<SignInScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection('Accounts');
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidepassword= true;
  bool buttonhideshow=false;
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadPic() async {
    Reference ref = FirebaseStorage.instance.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl.toString();
  }







  bool _visible = false;
  bool _isInProgress = false;
  bool _isClickonSignUp = false;
  bool _isClickonForgotPassword = false;
  bool _visiblesignUpbutton = true;
  GlobalKey<FormState> _userLoginFormKey = GlobalKey();
  User _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isSignIn =false;
  bool google =false;
  String phoneNumber, verificationId;
  String otp, authStatus = "";


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



  String email, password;
  String UserEmail, UserName, ImageUrl;
  bool verifyEmail;
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
            backgroundColor: AllCoustomTheme
                .getThemeData()
                .primaryColor,

            body: ModalProgressHUD(
              inAsyncCall: _isInProgress,
              opacity: 0,
              progressIndicator: SizedBox(),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: appBarheight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            builder: (anim) =>
                                FractionalTranslation(
                                  translation: anim.value,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AllCoustomTheme
                                        .getTextThemeColors(),
                                  ),
                                ),
                          ),
                        ),
                        !_isClickonSignUp
                            ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isClickonSignUp = true;
                            });
                            await Future.delayed(
                                const Duration(milliseconds: 700));

                            Navigator.of(context, rootNavigator: true)
                                .push(
                              CupertinoPageRoute<void>(
                                builder: (BuildContext context) =>
                                    SignUpScreen(),
                              ),
                            )
                                .then((onValue) {
                              setState(() {
                                _isClickonSignUp = false;
                              });
                            });
                          },
                          child: Animator(
                            tween: Tween<double>(begin: 0.8, end: 1.1),
                            curve: Curves.easeInToLinear,
                            cycles: 0,
                            builder: (anim) =>
                                Transform.scale(
                                  scale: anim.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16),
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontSize: ConstanceData
                                            .SIZE_TITLE18,
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
                      height: 40,
                    ),
                    Row(
                      children: <Widget>[
                        Animator(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500),
                          cycles: 1,
                          builder: (anim) =>
                              SizeTransition(
                                sizeFactor: anim,
                                axis: Axis.horizontal,
                                axisAlignment: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AllCoustomTheme
                                          .getTextThemeColors(),
                                      fontSize: 36,
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
                      padding: const EdgeInsets.only(left: 16),
                      child: _visible
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30)),
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
                                        validator: _validateEmail,
                                        cursorColor: AllCoustomTheme
                                            .getTextThemeColors(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData
                                              .SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                        onChanged: (value) {
                                          email =
                                              value; //get the value entered by user.
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: new InputDecoration(
                                          focusColor: AllCoustomTheme
                                              .getTextThemeColors(),
                                          fillColor: AllCoustomTheme
                                              .getTextThemeColors(),
                                          hintText: 'Enter email here...',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: ConstanceData
                                                  .SIZE_TITLE14),
                                          labelText: 'E-mail',
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
                                          left: 14, bottom: 10),
                                      child: TextFormField(
                                        cursorColor: AllCoustomTheme
                                            .getTextThemeColors(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData
                                              .SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                        onChanged: (value) {
                                          password =
                                              value; //get the value entered by user.
                                        },
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        decoration: new InputDecoration(
                                          focusColor: AllCoustomTheme
                                              .getTextThemeColors(),
                                          fillColor: AllCoustomTheme
                                              .getTextThemeColors(),
                                          hintText: 'Enter password here...',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: ConstanceData
                                                  .SIZE_TITLE14),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            fontSize: ConstanceData
                                                .SIZE_TITLE16,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
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
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 14, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    !_isClickonForgotPassword
                                        ? GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isClickonForgotPassword = true;
                                        });
                                        await Future.delayed(const Duration(
                                            milliseconds: 700));

                                        Navigator.of(
                                            context, rootNavigator: true)
                                            .push(
                                          CupertinoPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                ForgotPasswordScreen(),
                                          ),
                                        )
                                            .then((onValue) {
                                          setState(() {
                                            _isClickonForgotPassword =
                                            false;
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    )
                                        : Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: CupertinoActivityIndicator(
                                        radius: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: !_isInProgress
                                          ? GestureDetector(
                                        onTap: () {
                                          _submit();
                                        },
                                        child: Animator(
                                          tween: Tween<double>(
                                              begin: 0.8, end: 1.1),
                                          curve: Curves.easeInToLinear,
                                          cycles: 0,
                                          builder: (anim) =>
                                              Transform.scale(
                                                scale: anim.value,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    border: new Border.all(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      begin: Alignment
                                                          .topLeft,
                                                      end: Alignment
                                                          .bottomRight,
                                                      colors: [
                                                        globals
                                                            .buttoncolor1,
                                                        globals
                                                            .buttoncolor2,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 3),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios,
                                                      size: 20,
                                                      color: AllCoustomTheme
                                                          .getTextThemeColors(),
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
                    ),
                    SizedBox(
                      height: 10,
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
                            border: Border.all(
                                color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                globals.buttoncolor1,
                                globals.buttoncolor2,
                              ],
                            ),
                          ),
                          child: Text(
                            "Sign In With Gmail",
                            style: TextStyle(
                              color: AllCoustomTheme
                                  .getReBlackAndWhiteThemeColors(),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isInProgress = true;
                          });
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          signInWithGoogle()
                              .then((FirebaseUser user) {
                            // model.clearAllModels();
                            Navigator.of(context)
                                .push(
                              CupertinoPageRoute<void>(
                                  // builder: (BuildContext context) =>
                                      // HomeScreen(e)
                              ),
                            )
                                .then((onValue) {
                              setState(() {

                              });
                            });
                            // Navigator.of(context).pushNamedAndRemoveUntil
                            //   (RouteName.Home, (Route<dynamic> route) => false
                            // );
                          }
                          ).catchError((e) => print(e));

                          _isInProgress = false;
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
                            "Sign In with Phone Number",
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

                          Navigator.of(context)
                              .push(
                            CupertinoPageRoute<void>(
                              builder: (BuildContext context) => PhoneVerify(),
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

                    // InkWell(
                    //   child: Container(
                    //       width: 30,
                    //       height: 38,
                    //       margin: EdgeInsets.only(top: 25),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: Colors.black
                    //       ),
                    //       child: Center(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment
                    //                 .spaceEvenly,
                    //             children: <Widget>[
                    //               Container(
                    //                 height: 30.0,
                    //                 width: 30.0,
                    //                 decoration: BoxDecoration(
                    //                   image: DecorationImage(
                    //                       image:
                    //                       AssetImage('assets/google.jpg'),
                    //                       fit: BoxFit.cover),
                    //                   shape: BoxShape.circle,
                    //                 ),
                    //               ),
                    //               Text('Sign in with Google',
                    //                 style: TextStyle(
                    //                     fontSize: 16.0,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.white
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //       )
                    //   ),
                    //   onTap: () async {
                    //     signInWithGoogle()
                    //         .then((FirebaseUser user) {
                    //       // model.clearAllModels();
                    //       Navigator.of(context).pushNamedAndRemoveUntil
                    //         (RouteName.Home, (Route<dynamic> route) => false
                    //       );
                    //     }
                    //     ).catchError((e) => print(e));
                    //   },
                    // ),
                    //
                    // SizedBox(
                    //   height: 10,
                    // ),
                    _visible
                        ? Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Terms & Privacy Policy',
                              style: TextStyle(
                                color: AllCoustomTheme
                                    .getsecoundTextThemeColor(),
                              ),
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
          )
        ],

    );
  }
  var myScreenFocusNode = FocusNode();

  _submit() async {
    setState(() {
      _isInProgress = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    FocusScope.of(context).requestFocus(myScreenFocusNode);
    if (_formKey.currentState.validate() == false) {
      setState(() {
        _isInProgress = false;
      });
      return;
    }
    _formKey.currentState.save();
    final _auth = FirebaseAuth.instance;

    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (newUser != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.Home, (Route<dynamic> route) => false);
        //successfully login
        //navigate the user to main page
        // i am just showing toast message here
      }
    } catch (e) {}

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
    }
    else if (value.length < 5) {
      return 'Password must contains ${5} characters';
    }
    else {
    return null;
      }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    // model.state =ViewState.Busy;

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =

    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(

      accessToken: googleSignInAuthentication.accessToken,

      idToken: googleSignInAuthentication.idToken,

    );

    UserCredential authResult = await _auth.signInWithCredential(credential);

    _user = authResult.user;

    assert(!_user.isAnonymous);

    assert(await _user.getIdToken() != null);

    User currentUser = await _auth.currentUser;

    assert(_user.uid == currentUser.uid);


    ViewState.Idle;

    UserEmail = _user.email;
    UserName = _user.displayName;
    ImageUrl = _user.photoUrl;
    verifyEmail = _user.emailVerified;

    // print("User Name: ${_user.displayName}");
    // print("User Email ${_user.email}");

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
