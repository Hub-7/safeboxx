import 'package:animator/animator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeboxx/auth/signInScreen.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/routes.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeboxx/localizations.dart';
import 'package:safeboxx/model/auth_service.dart';
import 'package:safeboxx/modules/drawer/drawer.dart';
import 'package:safeboxx/modules/home/homeScreen.dart';



import '../imports.dart';
import 'home_page.dart';




class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

String getURL=null;
class _SignUpScreenState extends State<SignUpScreen> {
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









  bool _isInProgress = false;
  bool _isClickonSignIn = false;
  bool _visible = false;

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();




  animation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _visible = true;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    animation();

  }


  String email, password;
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
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
                                            'Sign In',
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
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _visible
                            ? GestureDetector(
                          onTap: (){
                            getImage();
                          },

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

                                        height: 60,
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
                                                controller: usernameController,
                                                onChanged: (value) => null,
                                                onSaved: (value) {
                                                  setState(() {

                                                    _name.text = value;
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
                                                keyboardType: TextInputType.text,
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
                                                controller: emailController,

                                                onSaved: (value) {
                                                  setState(() {
                                                     _email.text = value;
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
                                              padding: EdgeInsets.only(left: 14, bottom: 10),
                                              child: TextFormField(
                                                controller: passwordController,
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

                                                maxLines: 1,

                                                onSaved: (value) {
                                                  setState(() {
                                                      _password.text = value;
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
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20, left: 14, right: 10),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.end,
                                      //     children: <Widget>[
                                      //
                                      //       SizedBox(
                                      //         height: 50,
                                      //         child: !_isInProgress
                                      //             ? GestureDetector(
                                      //                 onTap: () async {
                                      //                   _submit();
                                      //                   if (_formKey.currentState.validate()) {
                                      //                     SystemChannels.textInput.invokeMethod(
                                      //                         'TextInput.hide'); //to hide the keyboard - if any
                                      //                     AuthService _auth = AuthService();
                                      //                     bool _isRegisterSucccess =
                                      //                         await _auth.registerWithEmailAndPassword(
                                      //                         _name.text, _email.text, _password.text);
                                      //
                                      //                     if (_isRegisterSucccess == false) {
                                      //                       _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      //                         content: Text(labels.auth.signUpError),
                                      //                       ));
                                      //                     }
                                      //                   }
                                      //                 },
                                      //                 child: Animator(
                                      //                   tween: Tween<double>(begin: 0.8, end: 1.1),
                                      //                   curve: Curves.easeInToLinear,
                                      //                   cycles: 0,
                                      //                   builder: (anim) => Transform.scale(
                                      //                     scale: anim.value,
                                      //
                                      //                     child: Container(
                                      //
                                      //                       height: 50,
                                      //                       width: 50,
                                      //                       decoration: BoxDecoration(
                                      //                         border: new Border.all(color: Colors.white, width: 1.5),
                                      //                         shape: BoxShape.circle,
                                      //                         gradient: LinearGradient(
                                      //                           begin: Alignment.topLeft,
                                      //                           end: Alignment.bottomRight,
                                      //                           colors: [
                                      //                             globals.buttoncolor1,
                                      //                             globals.buttoncolor2,
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //
                                      //                       child: Padding(
                                      //                         padding: const EdgeInsets.only(left: 3),
                                      //                         child: Icon(
                                      //                           Icons.arrow_forward_ios,
                                      //                           size: 20,
                                      //                           color: AllCoustomTheme.getTextThemeColors(),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //
                                      //                   ),
                                      //                 ),
                                      //               )
                                      //             : Padding(
                                      //                 padding: EdgeInsets.only(right: 14),
                                      //                 child: CupertinoActivityIndicator(
                                      //                   radius: 12,
                                      //                 ),
                                      //               ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.blue.withOpacity(0.5),
                                      blurRadius: 20 ,
                                    ),

                                  ]
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: RaisedButton(
                                  child: Text('Add New Account',style: TextStyle(color: AllCoustomTheme.getsecoundTextThemeColor(),fontWeight: FontWeight.w400,fontSize: 20),),
                                  onPressed: buttonhideshow?null:()async{
                                    if (_formKey.currentState.validate()){
                                      setState(() {
                                        buttonhideshow=true;
                                      });
                                      if(_image!=null)
                                      {

                                        getURL= await uploadPic();
                                        if(getURL.isNotEmpty)
                                        {
                                          await collectionReference.add({'UserName':usernameController.text,
                                            'Email':emailController.text,
                                            'Password': passwordController.text,
                                            'PhoneNum': "",
                                            'Balance': "0.00",
                                            'VerifiedPhone': "Not Verified",
                                            'VerifiedEmail': "Not Verified",
                                            'AccountNum': "",
                                            'AccountName': "",
                                            'Bank': "",

                                            'URL':getURL.toString()
                                          }).then((value) {
                                            usernameController.text="";
                                            emailController.text="";

                                            passwordController.text="";


                                            setState(() {
                                              buttonhideshow=false;
                                            });
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    CupertinoAlertDialog(
                                                      title: new Text("Success!"),
                                                      content: new Text("Registration successful"),
                                                      actions: <Widget>[
                                                        CupertinoDialogAction(
                                                          child: Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.of(context).push(
                                                              CupertinoPageRoute<void>(
                                                                builder: (BuildContext context) => HomeScreen(),
                                                              ),
                                                            );
                                                            // Navigator.pushNamedAndRemoveUntil(context, Routes.Home, (Route<dynamic> route) => false);
                                                            /*Navigator.pushNamed(
                                                        context, "MainPage");*/
                                                          },
                                                        )
                                                      ],
                                                    ));
                                          });
                                        }



                                      }
                                      else{
                                        setState(() {
                                          buttonhideshow=false;
                                        });
                                        showDialog(
                                          //barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: new Text("ERROR!"),
                                                  content: new Text("Please Select Profile Image"),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        /*Navigator.pushNamed(
                                                        context, "MainPage");*/
                                                      },
                                                    )
                                                  ],
                                                ));
                                      }
                                      color: Colors.blue;


                                    }

                                    //  Navigator.pushNamed(context, "Account");
                                  },
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 50,
                              decoration: BoxDecoration(
                                                        border: new Border.all(color: Colors.white, width: 1.5),
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            globals.buttoncolor1,
                                                          ],
                                                        ),
                                                      ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: RaisedButton(
                                  child: Text('Add New Account',style: TextStyle(color: AllCoustomTheme.getsecoundTextThemeColor(),fontWeight: FontWeight.w400,fontSize: 20),),
                                  onPressed: buttonhideshow?null:()async{
                                    if (_formKey.currentState.validate()){
                                      setState(() {
                                        buttonhideshow=true;
                                      });
                                      if(_image!=null)
                                      {

                                        getURL= await uploadPic();
                                        if(getURL.isNotEmpty)
                                        {
                                          await collectionReference.add({'UserName':usernameController.text,
                                            'Email':emailController.text,
                                            'Password': passwordController.text,
                                            'PhoneNum': "",
                                            'Balance': "0.00",
                                            'VerifiedPhone': "Not Verified",
                                            'VerifiedEmail': "Not Verified",
                                            'AccountNum': "",
                                            'AccountName': "",
                                            'Bank': "",

                                            'URL':getURL.toString()
                                          }).then((value) {
                                            usernameController.text="";
                                            emailController.text="";

                                            passwordController.text="";


                                            setState(() {
                                              buttonhideshow=false;
                                            });
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    CupertinoAlertDialog(
                                                      title: new Text("Success!"),
                                                      content: new Text("Registration successful"),
                                                      actions: <Widget>[
                                                        CupertinoDialogAction(
                                                          child: Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.of(context).push(
                                                              CupertinoPageRoute<void>(
                                                                builder: (BuildContext context) => HomeScreen(),
                                                              ),
                                                            );
                                                            // Navigator.pushNamedAndRemoveUntil(context, Routes.Home, (Route<dynamic> route) => false);
                                                            /*Navigator.pushNamed(
                                                        context, "MainPage");*/
                                                          },
                                                        )
                                                      ],
                                                    ));
                                          });
                                        }



                                      }
                                      else{
                                        setState(() {
                                          buttonhideshow=false;
                                        });
                                        showDialog(
                                          //barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: new Text("ERROR!"),
                                                  content: new Text("Please Select Profile Image"),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        /*Navigator.pushNamed(
                                                        context, "MainPage");*/
                                                      },
                                                    )
                                                  ],
                                                ));
                                      }
                                      color: Colors.blue;


                                    }

                                    //  Navigator.pushNamed(context, "Account");
                                  },
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
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
