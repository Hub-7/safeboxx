import 'package:animator/animator.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/global.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:safeboxx/modules/userProfile/EditProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isInProgress = false;
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection('Accounts');

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  loadUserDetails() async {
    setState(() {
      _isInProgress = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _isInProgress = false;
    });
  }

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
            progressIndicator: CupertinoActivityIndicator(
              radius: 12,
            ),
            child: StreamBuilder(
    stream: collectionReference.snapshots(),
    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
    if(snapshot.hasData)

              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: !_isInProgress
                    ? snapshot.data.docs.map((e) => Column(

                        children: <Widget>[
                          SizedBox(
                            height: appBarheight,
                          ),


                          Row(
                            children: <Widget>[
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
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
                              Expanded(
                                child: Animator(

                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.decelerate,
                                  cycles: 1,
                                  builder: (anim) => Transform.scale(
                                    scale: anim.value,
                                    child: Text(
                                      'User Profile',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AllCoustomTheme.getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: ConstanceData.SIZE_TITLE20,
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                              InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                        builder: (BuildContext context) => EditData(e)));},
                                  child: Image.asset('assets/edit1.png',height: 25,))
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Name',
                                style: TextStyle(
                                  color: AllCoustomTheme.getsecoundTextThemeColor(),
                                  fontSize: ConstanceData.SIZE_TITLE16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Text(
                                'Nnadi Henry',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: false,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AnimatedDivider(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'E-Mail',
                                style: TextStyle(
                                  color: AllCoustomTheme.getsecoundTextThemeColor(),
                                  fontSize: ConstanceData.SIZE_TITLE16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'nnadihenry92@gmail.com',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: false,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: AllCoustomTheme.getsecoundTextThemeColor(),
                                  fontSize: ConstanceData.SIZE_TITLE16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '+2348139264713',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: false,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AnimatedDivider(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Account Details',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: true,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: AnimatedDivider(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Change Password',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: true,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: AnimatedDivider(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Delete account',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                              AnimatedForwardArrow(
                                isShowingarroeForward: true,
                              ),
                            ],
                          ),
                        ],
                      ))
                    : SizedBox(),
              );
      return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Center(child: CircularProgressIndicator()),
      ],
      );
    }
            ),
          ),
        )
      ],
    );
  }
}
