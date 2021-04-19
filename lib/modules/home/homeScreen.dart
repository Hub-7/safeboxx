import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:safeboxx/Widgets/ColumnReusableCardButton.dart';
import 'package:safeboxx/Widgets/RowReusableCardButton.dart';
import 'package:safeboxx/auth/authenticationScreen.dart';
import 'package:safeboxx/constance/constance.dart';
import 'package:safeboxx/constance/global.dart';
import 'package:safeboxx/constance/themes.dart';
import 'package:safeboxx/graphDetail/OHLCVGraph.dart';
import 'package:safeboxx/graphDetail/QuickPercentChangeBar.dart';
import 'package:safeboxx/main.dart';
import 'package:safeboxx/model/listingsModel.dart';
import 'package:safeboxx/modules/chagePIN/changepin.dart';
import 'package:safeboxx/modules/drawer/drawer.dart';
import 'package:safeboxx/modules/muitisig/multisig.dart';
import 'package:safeboxx/modules/myWallet/wallet.dart';
// import 'package:safeboxx/modules/news/latestCryptoNews.dart';
import 'package:safeboxx/modules/underGroundSlider/cryptoCoinDetailSlider.dart';
import 'package:safeboxx/modules/underGroundSlider/notificationSlider.dart';
import 'package:safeboxx/modules/userProfile/userProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeboxx/constance/global.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:safeboxx/utils/Resources.dart';
import 'package:safeboxx/utils/constants.dart';
import 'package:safeboxx/utils/custom_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:safeboxx/FirebaseAnalytics.dart';
import 'package:safeboxx/imports.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget with AnalyticsScreen {
  // QueryDocumentSnapshot e;
  // HomeScreen(QueryDocumentSnapshot e){
  //   this.e=e;
  // }
  @override
  _HomeScreenState createState() => _HomeScreenState();
  String get screenName => 'User Dashboard';
}

const String testDevice = 'YOUR_DEVICE_ID';

class _HomeScreenState extends State<HomeScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection('Accounts');
  final _formKey = GlobalKey<FormState>();
  String userbalanceController1;


  TextEditingController userbalanceController = TextEditingController();



  bool _isInProgress = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;
  bool _isSearch = false;
  bool allCoin = false;
  bool isLoading = false;

  var width = 0.0;
  var height = 0.0;
  var appBarheight = 0.0;
  var statusBarHeight = 0.0;
  var graphHeight = 0.0;
  List<CryptoCoinDetail> _serchCoinList = [];
  var marketCapUpDown;

  String historyAmt = "720";
  String historyType = "minute";
  String historyTotal = "24h";
  String historyAgg = "2";
  String _high = "0";
  String _low = "0";
  String _change = "0";
  String symbol = 'NGN';

  USD generalStats;
  int currentOHLCVWidthSetting = 0;
  List historyOHLCV;

  var subscription;

  List<CryptoCoinDetail> lstCryptoCoinDetail = [];

  AdmobBannerController admobBannerController;

  @override
  void initState() {
    // userbalanceController1 = widget.e['Balance'];
    // userbalanceController = TextEditingController()..text=widget.e['Balance'];
    super.initState();
    setFirstTab();
    callItself();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.index); // 0=wifi, 1=mobile, 2=none
      if (result.index != 2) {
        setFirstTab();
        callItself();
        marketCapUpDown = Icons.arrow_upward;
      } else {
        connectionError();
      }
    });
    bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
    admobBannerController.dispose();
  }

  connectionError() {
    showInSnackBar(ConstanceData.NoInternet);
  }

  Future showInSnackBar(String value, {bool isGreeen = false}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          value,
          style: TextStyle(
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: isGreeen ? AllCoustomTheme.getThemeData().primaryColor : Colors.red,
      ),
    );
  }

  isLoadingList() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  Future<Null> getApiAllData(int index) async {
    List<CryptoCoinDetail> allCoinList = [];
    allCoinList.clear();
    List<CryptoCoinDetail> coindata = await getData1(index);
    coindata = await getData1(index);
    if (coindata != null) {
      if (coindata.length != 0) {
        index += coindata.length;
        if (index == 1) {
          setState(() {
            allCoinList.addAll(coindata);
          });
        } else {
          allCoinList.addAll(coindata);
          setState(() {
            allCoinList.removeWhere((length) => length.quote.uSD.marketCap == null);
            if (allCoin == true) {
              getApiAllData(index);
            }
            lstCryptoCoinDetail.clear();
            lstCryptoCoinDetail.addAll(allCoinList);
            lstCryptoCoinDetail.sort((a, b) => b.quote.uSD.marketCap.compareTo(a.quote.uSD.marketCap));
            print(lstCryptoCoinDetail[0].quote.uSD);

            marketListData.clear();
            marketListData.addAll(allCoinList);
            marketListData.sort((a, b) => b.quote.uSD.marketCap.compareTo(a.quote.uSD.marketCap));
          });
        }
      }
    }
  }

  callItself() async {
    getApiAllData(1);
    changeHistory(historyType, historyAmt, historyTotal, historyAgg);
    await Future.delayed(Duration(hours: 1));
    callItself();
  }

  Future<Null> changeHistory(String type, String amt, String total, String agg) async {
    setState(() {
      _high = "0";
      _low = "0";
      _change = "0";

      historyAmt = amt;
      historyType = type;
      historyTotal = total;
      historyAgg = agg;

      historyOHLCV = null;
    });
    //getGeneralStats();
    _makeGeneralStats();
    await getHistoryOHLCV();
    _getHL();
  }

  _makeGeneralStats() {
    for (CryptoCoinDetail coin in marketListData) {
      if (coin.symbol == symbol) {
        generalStats = coin.quote.uSD;
        setState(() {});
        break;
      }
    }
  }

  _getHL() {
    num highReturn = -double.infinity;
    num lowReturn = double.infinity;

    for (var i in historyOHLCV) {
      if (i["high"] > highReturn) {
        highReturn = i["high"].toDouble();
      }
      if (i["low"] < lowReturn) {
        lowReturn = i["low"].toDouble();
      }
    }

    _high = normalizeNumNoCommas(highReturn);
    _low = normalizeNumNoCommas(lowReturn);

    var start = historyOHLCV[0]["open"] == 0 ? 1 : historyOHLCV[0]["open"];
    var end = historyOHLCV.last["close"];
    var changePercent = (end - start) / start * 100;
    _change = changePercent.toStringAsFixed(2);
  }

  Future<Null> getHistoryOHLCV() async {
    var response = await http.get(
        Uri.encodeFull("https://min-api.cryptocompare.com/data/histo" +
            ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][3] +
            "?fsym=" +
            symbol +
            "&tsym=USD&limit=" +
            (ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][1] - 1).toString() +
            "&aggregate=" +
            ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][2].toString()),
        headers: {"Accept": "application/json"});
    setState(() {
      historyOHLCV = new JsonDecoder().convert(response.body)["Data"];
      if (historyOHLCV == null) {
        historyOHLCV = [];
      }
    });
  }

  setFirstTab() {
    setState(() {
      isSelect1 = true;
      isSelect2 = false;
      isSelect3 = false;
    });
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signOutGoogle() async{
    await _googleSignIn.signOut();
    print("User Sign Out");
  }
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    appBarheight = appBar.preferredSize.height;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    statusBarHeight = MediaQuery.of(context).padding.top;

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
        SafeArea(

          bottom: true,
          child: Scaffold(
            key: _scaffoldKey,
            bottomNavigationBar: Container(
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        isSelect1
                            ? Animator(
                                duration: Duration(milliseconds: 500),
                                cycles: 1,
                                builder: (anim) => Transform.scale(
                                  scale: anim.value,
                                  child: Container(
                                    height: 2,
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
                              )
                            : SizedBox(
                                height: 2,
                              ),
                        GestureDetector(
                          onTap: () {
                            selectFirst();
                          },
                          child: isSelect1
                              ? Animator(
                                  tween: Tween<double>(begin: 0.8, end: 1.1),
                                  curve: Curves.decelerate,
                                  cycles: 1,
                                  builder: (anim) => Transform.scale(
                                    scale: anim.value,
                                    child: Container(
                                      height: 40,
                                      width: width / 3,
                                      color: Colors.transparent,
                                      child: Icon(
                                        Icons.card_travel,
                                        color: isSelect1 ? AllCoustomTheme.getTextThemeColors() : AllCoustomTheme.getsecoundTextThemeColor(),
                                      ),
                                    ),
                                  ),
                                )
                              : firstAnimation(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        isSelect2
                            ? Animator(
                                duration: Duration(milliseconds: 500),
                                cycles: 1,
                                builder: (anim) => Transform.scale(
                                  scale: anim.value,
                                  child: Container(
                                    height: 2,
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
                              )
                            : SizedBox(
                                height: 2,
                              ),
                        GestureDetector(
                          onTap: () {
                            selectSecond();
                          },
                          child: isSelect2
                              ? Animator(
                                  tween: Tween<double>(begin: 0.8, end: 1.1),
                                  curve: Curves.decelerate,
                                  cycles: 1,
                                  builder: (anim) => Transform.scale(
                                    scale: anim.value,
                                    child: secondAnimation(),
                                  ),
                                )
                              : secondAnimation(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        isSelect3
                            ? Animator(
                                duration: Duration(milliseconds: 500),
                                cycles: 1,
                                builder: (anim) => Transform.scale(
                                  scale: anim.value,
                                  child: Container(
                                    height: 2,
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
                              )
                            : SizedBox(
                                height: 2,
                              ),
                        GestureDetector(
                          onTap: () {
                            selectThird();
                          },
                          child: isSelect3
                              ? Animator(
                                  tween: Tween<double>(begin: 0.8, end: 1.1),
                                  curve: Curves.decelerate,
                                  cycles: 1,
                                  builder: (anim) => Transform.scale(
                                    scale: anim.value,
                                    child: thirdAnimation(),
                                  ),
                                )
                              : thirdAnimation(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
              child: Drawer(
                elevation: 0,
                child: AppDrawer(
                  selectItemName: 'home',
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: _isInProgress,
              opacity: 0,
              progressIndicator: SizedBox(),
              child: Container(
                height: height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Expanded(
                      child: isSelect1
                          ? firstScreen()
                          : isSelect2
                              ? secoundScreen()
                              : thirdScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget firstAnimation() {
    return Container(
      height: 40,
      width: width / 3,
      color: Colors.transparent,
      child: Icon(
        Icons.card_travel,
        color: isSelect1 ? AllCoustomTheme.getTextThemeColors() : AllCoustomTheme.getsecoundTextThemeColor(),
      ),
    );
  }

  Widget secondAnimation() {
    return Container(
      height: 40,
      width: width / 3,
      color: Colors.transparent,
      child: Icon(
        Icons.pie_chart,
        color: isSelect2 ? AllCoustomTheme.getTextThemeColors() : AllCoustomTheme.getsecoundTextThemeColor(),
      ),
    );
  }

  Widget thirdAnimation() {
    return Container(
      height: 40,
      width: width / 3,
      color: Colors.transparent,
      child: Icon(
        Icons.settings,
        color: isSelect3 ? AllCoustomTheme.getTextThemeColors() : AllCoustomTheme.getsecoundTextThemeColor(),
      ),
    );
  }

  Widget firstScreen() {

    graphHeight = height - appBarheight - 42;

    return Container(
      height: graphHeight,
      key: _formKey,
      child: Column(

        // body: Padding(
        //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //   child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

          Padding(

          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.sort,
                  color: AllCoustomTheme.getsecoundTextThemeColor(),
                ),
              ),
              historyOHLCV != null
                  ? Animator(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
                cycles: 1,
                builder: (anim) => Transform.scale(
                  scale: anim.value,
                  child: Text(
                    'SafeBoxx',
                    style: TextStyle(color: AllCoustomTheme.getTextThemeColors(), fontSize: ConstanceData.SIZE_TITLE18),
                  ),
                ),
              )
                  : SizedBox(),
              Animator(
                duration: Duration(milliseconds: 500),
                tween: Tween<double>(begin: -0.1, end: 0.1),
                curve: Curves.decelerate,
                cycles: 0,
                builder: (anim) => Transform(
                  transform: Matrix4.skewX(anim.value),
                  child: Icon(
                    Icons.notifications,
                    color: AllCoustomTheme.getsecoundTextThemeColor(),
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
                          'Wallet',
                          style: TextStyle(
                            color: AllCoustomTheme.getsecoundTextThemeColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  right: 16,
                  left: 16,
                ),
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '\#',
                      style: TextStyle(
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontWeight: FontWeight.bold,
                        fontSize: ConstanceData.SIZE_TITLE20,
                      ),
                    ),
                    Animator(

                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 500),
                      cycles: 1,
                      builder: (anim) => SizeTransition(
                        sizeFactor: anim,
                        axis: Axis.horizontal,
                        axisAlignment: 1,
                        child:
                        Text("0.00",
                          style: TextStyle(
                            color: AllCoustomTheme.getTextThemeColors(),
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SizedBox(),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RowReusableCardButton(
                            tileColor: AllCoustomTheme.boxColor(),
                            label: string.profile,
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                  builder: (BuildContext context) => UserProfile(),
                                ),
                              );
                            },
                            icon: Icons.perm_contact_calendar,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            tileColor: AllCoustomTheme.boxColor(),
                            icon: Icons.receipt,
                            label: string.Asset,
                            onPressed: () {
                              // kopenPage(context, TimeTablePage());
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RowReusableCardButton(
                            tileColor: AllCoustomTheme.boxColor(),
                            icon: Icons.assessment,
                            label: string.investments,
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                  builder: (BuildContext context) => MyWallet(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            tileColor: AllCoustomTheme.boxColor(),
                            icon: Icons.attach_money,
                            label: string.Save,
                            onPressed: () {
                              // kopenPage(context, FeesPage());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        // ),
      // ),

    );
  }

  Widget secoundScreen() {
    print(lstCryptoCoinDetail[0]);
    graphHeight = height - appBarheight - 42;


    // Navigator.pop(context);
    Navigator.of(context).push(
    CupertinoPageRoute<void>(
    builder: (BuildContext context) => MultisigWallet(),
    ),
    );

    // return Container(
    //   height: graphHeight,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.only(right: 16, left: 16),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             InkWell(
    //               highlightColor: Colors.transparent,
    //               splashColor: Colors.transparent,
    //               onTap: () {
    //                 Navigator.of(context).push(
    //                   CupertinoPageRoute(
    //                     builder: (BuildContext context) => CryptoNews(),
    //                   ),
    //                 );
    //               },
    //               child: Icon(
    //                 Icons.info_outline,
    //                 color: AllCoustomTheme.getsecoundTextThemeColor(),
    //               ),
    //             ),
    //             Icon(
    //               Icons.more_horiz,
    //               color: AllCoustomTheme.getsecoundTextThemeColor(),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(right: 16, left: 16),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //
    //
    //           ],
    //         ),
    //       ),
    //       SizedBox(
    //         height: 30,
    //       ),
    //
    //       SizedBox(
    //         height: 20,
    //       ),
    //
    //     ],
    //   ),
    // );
  }

  Widget thirdScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController controller) {
              setState(() {
                admobBannerController = controller;
              });
            },
          ),
          SizedBox(
            height: 10,
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
                      'Settings',
                      style: TextStyle(
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontWeight: FontWeight.bold,
                        fontSize: ConstanceData.SIZE_TITLE25,
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
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'General',
                        style: TextStyle(
                          color: AllCoustomTheme.getsecoundTextThemeColor(),
                          fontSize: ConstanceData.SIZE_TITLE16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  globals.buttoncolor1,
                                  globals.buttoncolor2,
                                ],
                              ),
                            ),
                            height: height / 1.8,
                            child: Scaffold(
                              backgroundColor: Colors.transparent,
                              body: NotificationSlider(),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                        AnimatedForwardArrow(
                          isShowingarroeForward: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  AnimatedDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Time Preference',
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
                        'Alerts',
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
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Account',
                        style: TextStyle(
                          color: AllCoustomTheme.getsecoundTextThemeColor(),
                          fontSize: ConstanceData.SIZE_TITLE16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => UserProfile(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'User Profile',
                          style: TextStyle(
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                        AnimatedForwardArrow(
                          isShowingarroeForward: true,
                        ),
                      ],
                    ),
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
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => ChangePINCode(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Change PIN-code',
                          style: TextStyle(
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                        AnimatedForwardArrow(
                          isShowingarroeForward: true,
                        ),
                      ],
                    ),
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
    InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,

    onTap: () {
      _googleSignIn;
    Navigator.of(context).push(
    CupertinoPageRoute(
    builder: (BuildContext context) => AuthenticationScreen(),
    ),
    );
    },
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                      AnimatedForwardArrow(
                        isShowingarroeForward: true,
                      ),
                    ],
                  ),
    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _upDownMarketCap() {
    isLoadingList();
    if (marketCapUpDown == Icons.arrow_upward) {
      setState(() {
        marketCapUpDown = Icons.arrow_downward;
        marketListData.sort((a, b) => a.quote.uSD.marketCap.compareTo(b.quote.uSD.marketCap));
      });
    } else {
      setState(() {
        marketCapUpDown = Icons.arrow_upward;
        marketListData.sort((a, b) => b.quote.uSD.marketCap.compareTo(a.quote.uSD.marketCap));
      });
    }
  }

  void filterSearchResults(String query) {
    isLoadingList();
    _serchCoinList.clear();
    if (query != "") {
      marketListData.forEach((coin) {
        if (coin.symbol.toString().contains(query) ||
            coin.symbol.toString().toLowerCase().contains(query) ||
            coin.symbol.toString().toUpperCase().contains(query) ||
            coin.name.toString().contains(query) ||
            coin.name.toString().toLowerCase().contains(query) ||
            coin.name.toString().toUpperCase().contains(query)) {
          _serchCoinList.add(coin);
        }
      });
      setState(() {
        _isSearch = true;
      });
    } else {
      setState(() {
        _isSearch = false;
      });
    }
  }

  selectFirst() async {
    if (!isSelect1) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        setFirstTab();
        callItself();
      }
      setState(() {
        isSelect1 = true;
        isSelect2 = false;
        isSelect3 = false;
      });
    }
  }

  selectSecond() async {
    if (!isSelect2) {
      setState(() {
        isSelect1 = false;
        isSelect2 = true;
        isSelect3 = false;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        isLoadingList();
      }
    }
  }

  selectThird() {
    if (!isSelect3) {
      setState(() {
        isSelect1 = false;
        isSelect2 = false;
        isSelect3 = true;
      });
    }
  }
}
