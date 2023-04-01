import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/account/account_radio_tile.dart';
import 'package:provider/provider.dart';


class PrimaryAccountScreen extends StatefulWidget {
  static const routename = "/primary";
  const PrimaryAccountScreen({Key? key}) : super(key: key);

  @override
  _PrimaryAccountScreenState createState() => _PrimaryAccountScreenState();
}

class _PrimaryAccountScreenState extends State<PrimaryAccountScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  List<Widget> listViewsEmpty = <Widget>[];
  List<Widget> listViewsFilled = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late String selectedAcc;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = AccountScreen(animationController: animationController);
    
/*     selectedAcc = Provider.of<AuthService>(context, listen: false)
        .loggedInUser
        .primaryAccount; */
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    // await ve3.fetchStoredAccounts();
    // print(ve3.storedAccounts);
    listViews = [];
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 10;
  }

  _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(68, 72, 214, 1), AppTheme.nearlyBlue])),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  FutureOr onGoBack(dynamic value) {
    animationController!.forward();
    setState(() {});
  }

  setPrimaryAcc(acc) {
    // setState(() {
    //   selectedAcc = acc;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _backgroundGradient(),
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    // var web3 = Provider.of<Web3Api>(context, listen: false);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            32,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      // itemCount: web3.storedAccounts.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext ctx, int index) {
        animationController?.forward();
        return AccountRadioTile(
          // accountName: web3.storedAccounts[index].name,
          // accountAddress: web3.storedAccounts[index].accountAddress,
          accountName: "name",
          accountAddress: "accountAddress",
          groupval: selectedAcc,
          func: setPrimaryAcc,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: const Interval((1 / 10) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        );
      },
    );

  }

  Widget getAppBarUI() {
    // var auth = Provider.of<AuthService>(context, listen: false);
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.nearlyDarkBlue
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 6,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                onPressed: (() {
                                  animationController?.reverse().then((value) {
                                    Navigator.of(context).pop();
                                  });
                                }),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.nearlyWhite,
                                  size: 30,
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Select Primary Account',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.nearlyWhite,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 70,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () async {
                                  // await auth.updatePrimaryAccount(selectedAcc);

                                  animationController?.reverse().then((value) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    // Text(
                                    //   "Save",
                                    //   style: TextStyle(
                                    //       fontFamily: AppTheme.fontName,
                                    //       color: Colors.red,
                                    //       fontSize: 18),
                                    // ),
                                    Center(
                                      child: Icon(Icons.save,
                                          color: AppTheme.nearlyWhite,
                                          size: 35),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // const SizedBox(height: 10,)
      ],
    );
  }
}
