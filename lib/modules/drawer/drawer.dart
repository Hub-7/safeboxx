import 'dart:math';

import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/global.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:safeboxx/modules/deposite/depositeCurrency.dart';
import 'package:safeboxx/modules/home/homeScreen.dart';
import 'package:safeboxx/modules/muitisig/multisig.dart';
import 'package:safeboxx/modules/myWallet/wallet.dart';
// import 'package:safeboxx/modules/tradingPair/tradingPair.dart';
import 'package:safeboxx/modules/withdraw/withdrawCurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:safeboxx/stores/login_store.dart';

import '../../imports.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;


  const AppDrawer({Key key, this.selectItemName}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

var appBarheight = 0.0;
final FirebaseAuth auth = FirebaseAuth.instance;


  final FirebaseUser user = auth.currentUser as FirebaseUser;
  final uid = user.uid;

  // here you write the codes to input the data into firestore

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
        builder: (_, loginStore, __) {
          AppBar appBar = AppBar();
          appBarheight = appBar.preferredSize.height;
          return Container(
            color: AllCoustomTheme
                .getThemeData()
                .primaryColor,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: appBarheight + 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
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
                                child: Image.asset(
                                  ConstanceData.planetImage,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Animator(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500),
                          cycles: 1,

                          builder: (anim) =>
                              SizeTransition(
                                sizeFactor: anim,
                                axis: Axis.horizontal,
                                axisAlignment: 1,

                                child: Text("USER",
                                  style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontWeight: FontWeight.bold,
                                  ),

                                ),

                              ),

                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Animator(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 500),
                    cycles: 1,
                    builder: (anim) =>
                        SizeTransition(
                          sizeFactor: anim,
                          axis: Axis.horizontal,
                          axisAlignment: 1,
                          child: Container(
                            height: 1.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  buttoncolor1,
                                  buttoncolor2,
                                ],
                              ),
                            ),
                          ),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Accounts',
                              style: TextStyle(
                                color: AllCoustomTheme
                                    .getsecoundTextThemeColor(),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      // builder: (BuildContext context) =>
                                      //     HomeScreen(),
                                    ),
                                  );
                                },
                                child: Row(
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
                                            child: Icon(
                                              Icons.markunread_mailbox,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Animator(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 1,
                                      builder: (anim) =>
                                          SizeTransition(
                                            sizeFactor: anim,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1,
                                            child: Text(
                                              'Home',
                                              style: TextStyle(
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    widget.selectItemName == 'home'
                                        ? Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Animator(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        cycles: 1,
                                        builder: (anim) =>
                                            Transform.scale(
                                              scale: anim.value,
                                              child: CircleAvatar(
                                                backgroundColor: globals
                                                    .buttoncolor2,
                                                radius: 5,
                                              ),
                                            ),
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          MultisigWallet(),
                                    ),
                                  );
                                },
                                child: Row(
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
                                            child: Icon(
                                              Icons.account_balance_wallet,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Animator(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 1,
                                      builder: (anim) =>
                                          SizeTransition(
                                            sizeFactor: anim,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1,
                                            child: Text(
                                              'Accounts',
                                              style: TextStyle(
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    widget.selectItemName == 'multisig'
                                        ? Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Animator(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        cycles: 1,
                                        builder: (anim) =>
                                            Transform.scale(
                                              scale: anim.value,
                                              child: CircleAvatar(
                                                backgroundColor: globals
                                                    .buttoncolor2,
                                                radius: 5,
                                              ),
                                            ),
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          MyWallet(),
                                    ),
                                  );
                                },
                                child: Row(
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
                                            child: Icon(
                                              Icons.account_balance_wallet,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Animator(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 1,
                                      builder: (anim) =>
                                          SizeTransition(
                                            sizeFactor: anim,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1,
                                            child: Text(
                                              'Wallet',
                                              style: TextStyle(
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    widget.selectItemName == 'wallet'
                                        ? Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Animator(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        cycles: 1,
                                        builder: (anim) =>
                                            Transform.scale(
                                              scale: anim.value,
                                              child: CircleAvatar(
                                                backgroundColor: globals
                                                    .buttoncolor2,
                                                radius: 5,
                                              ),
                                            ),
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Payments',
                                    style: TextStyle(
                                      color: AllCoustomTheme
                                          .getsecoundTextThemeColor(),
                                      fontSize: ConstanceData.SIZE_TITLE14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          DepositeCurrency(),
                                    ),
                                  );
                                },
                                child: Row(
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
                                            child: Icon(
                                              Icons.arrow_upward,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Animator(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 1,
                                      builder: (anim) =>
                                          SizeTransition(
                                            sizeFactor: anim,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1,
                                            child: Text(
                                              'Deposite',
                                              style: TextStyle(
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    widget.selectItemName == 'deposite'
                                        ? Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Animator(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        cycles: 1,
                                        builder: (anim) =>
                                            Transform.scale(
                                              scale: anim.value,
                                              child: CircleAvatar(
                                                backgroundColor: globals
                                                    .buttoncolor2,
                                                radius: 5,
                                              ),
                                            ),
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          WithDrawCurrency(),
                                    ),
                                  );
                                },
                                child: Row(
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
                                            child: Icon(
                                              Icons.arrow_downward,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Animator(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 1,
                                      builder: (anim) =>
                                          SizeTransition(
                                            sizeFactor: anim,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1,
                                            child: Text(
                                              'Withdraw',
                                              style: TextStyle(
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    widget.selectItemName == 'withdraw'
                                        ? Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Animator(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        cycles: 1,
                                        builder: (anim) =>
                                            Transform.scale(
                                              scale: anim.value,
                                              child: CircleAvatar(
                                                backgroundColor: globals
                                                    .buttoncolor2,
                                                radius: 5,
                                              ),
                                            ),
                                      ),
                                    )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'More',
                                    style: TextStyle(
                                      color: AllCoustomTheme
                                          .getsecoundTextThemeColor(),
                                      fontSize: ConstanceData.SIZE_TITLE14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Animator(
                                    tween: Tween<double>(begin: 0, end: 2 * pi),
                                    duration: Duration(milliseconds: 500),
                                    cycles: 0,
                                    builder: (anim) =>
                                        Transform.rotate(
                                          angle: anim.value,
                                          child: Icon(
                                            Icons.settings,
                                            color: AllCoustomTheme
                                                .getsecoundTextThemeColor(),
                                            size: 20,
                                          ),
                                        ),
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                    'Setting',
                                    style: TextStyle(
                                      color: AllCoustomTheme
                                          .getTextThemeColors(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  loginStore.signOut(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          WithDrawCurrency(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Animator(
                                      tween: Tween<double>(
                                          begin: 0, end: 2 * pi),
                                      duration: Duration(milliseconds: 500),
                                      cycles: 0,
                                      builder: (anim) =>
                                          Transform.rotate(
                                            angle: anim.value,
                                            child: Icon(
                                              Icons.logout,
                                              color: AllCoustomTheme
                                                  .getsecoundTextThemeColor(),
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),


                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
   _current(){
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() {
    final FirebaseUser user = auth.currentUser as FirebaseUser;
    final uid = user.uid;
    // here you write the codes to input the data into firestore
  }
  }
}
