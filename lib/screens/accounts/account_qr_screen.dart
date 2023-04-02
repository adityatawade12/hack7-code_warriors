import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/address_qr_box.dart';
import 'package:provider/provider.dart';

class AccountQrScreen extends StatefulWidget {
  static const routename = "/pnt";
  final String address;
  final String name;
  final String type;
  const AccountQrScreen({
    Key? key,
    required this.address,
    required this.name,
    required this.type,
  }) : super(key: key);

  @override
  _AccountQrScreenState createState() => _AccountQrScreenState();
}

class _AccountQrScreenState extends State<AccountQrScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationController;
  List<Widget> listViews = <Widget>[];
  List<Widget> listViewsEmpty = <Widget>[];
  List<Widget> listViewsFilled = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final args = {
      "address": widget.address,
      "name": widget.name,
      "type": widget.type
    };
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    // await ve3.fetchStoredAccounts();
    // print(ve3.storedAccounts);
    addAllListData(args);

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

  void addAllListData(args) {
    const int count = 10;
    listViews.add(const SizedBox(
      height: 100,
    ));

    listViews.add(
      AddressQrBox(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: const Interval((1 / count) * 2, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController!,
          address: args['address'],
          type: args["type"]),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            // HexColor('#6A88E5'),
            AppTheme.nearlyBlue,
            AppTheme.mainBlue,
            AppTheme.nearlyBlue
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Scaffold(
          // backgroundColor: AppTheme.mainBlue,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    var db = Provider.of<DbProvider>(context, listen: false);
    // return FutureBuilder(
    //   future: getData(),
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(
    //           color: AppTheme.mainBlue,
    //         ),
    //       );
    //     } else {
    //       print(snapshot.data);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        // if (listViews.length > 5) {
        //   if (index == 4) {
        //     return SizedBox();
        //   }
        //   widget.animationController?.forward();
        //   return listViews[index];
        // } else {
        //   widget.animationController?.forward();
        //   return listViews[index];
        // }
        animationController?.forward();
        return listViews[index];
      },
    );
    //     }
    //   },
    // );
  }

  Widget getAppBarUI() {
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
                    color: AppTheme.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
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
                            left: 0,
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
                                  size: 30,
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'AccountQR',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
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
        )
      ],
    );
  }
}
