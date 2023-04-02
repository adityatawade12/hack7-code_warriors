import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';



class TransactionDetailScreen extends StatefulWidget {
  static const routename = "/transactDetail";
  // final String address;
  final Map<String, dynamic> trns;
  final String address;
  final String currEx;
  const TransactionDetailScreen({
    Key? key,
    required this.trns,
    required this.address,
    required this.currEx,
    // required this.address,
    // required this.name,
  }) : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen>
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

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

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
    // listViews.add(SizedBox(
    //   height: 100,
    // ));

    listViews.add(
      TransactionWidget(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
        trns: widget.trns,
        address: widget.address,
        currEx: widget.currEx,
      ),
    );

    // listViews.add(
    //   TransactionsHeader(
    //     // titleTxt: 'Transactions',
    //     // subTxt: 'Add Account',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: animationController!,
    //         curve:
    //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: animationController!,
    //     onGoBack: onGoBack,
    //   ),
    // );
    // listViews.add(TransactionList(
    //   mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //       CurvedAnimation(
    //           parent: animationController!,
    //           curve: Interval((1 / 10) * 7, 1.0, curve: Curves.fastOutSlowIn))),
    //   mainScreenAnimationController: animationController!,
    //   address: args['address'],
    // ));
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
    print("loading page");
    return Container(
      child: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(colors: [
            //   // HexColor('#6A88E5'),
            //   AppTheme.nearlyBlue,
            //   AppTheme.mainBlue,
            //   AppTheme.nearlyBlue
            // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
        child: Scaffold(
          // backgroundColor: AppTheme.mainBlue,
          backgroundColor: AppTheme.nearlyWhite,
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
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.mainBlue,
            ),
          );
        } else {
          print(snapshot.data);

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
              animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
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
                          color: AppTheme.grey
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
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Transaction Details',
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

class TransactionWidget extends StatelessWidget {
  final Map<String, dynamic> trns;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String address;
  final String currEx;

  const TransactionWidget(
      {Key? key,
      this.animationController,
      this.animation,
      required this.trns,
      required this.address,
      required this.currEx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Transaction ID:",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      trns['transactionHash'],
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Divider(
                      height: 28,
                    ),
                    Text(
                      "Amount:",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      trns['receiver'] == address
                          ? '+ \u{20B9}${trns['amount']}'
                          : '- \u{20B9}${trns['amount']}',
                      // style: TextStyle(fontSize: 18),
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Val transaction:",
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1',
                                  style: TextStyle(fontSize: 19),
                                ),
                                Container(
                                  height: 20,
                                  child: Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
                                ),
                                Text(
                                  ' = \u{20B9}${trns['exchange']}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 19),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Curr. value: "),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1',
                                  style: TextStyle(fontSize: 19),
                                ),
                                Container(
                                  height: 20,
                                  child: Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
                                ),
                                Text(
                                  ' = \u{20B9}${currEx}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 19),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 28,
                    ),
                    Text(
                      "Sender:",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      trns['senderName'],
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Address: ${trns['sender']}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Divider(
                      height: 28,
                    ),
// ////////////////////////
                    Text(
                      "Receiver:",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      trns['receiverName'],
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Address: ${trns['receiver']}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}