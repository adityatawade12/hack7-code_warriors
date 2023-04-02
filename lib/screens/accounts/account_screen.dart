import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/account/account_header.dart';
import 'package:hack7/widgets/account/account_tile_list.dart';
import 'package:hack7/widgets/account/account_types.dart';
import 'package:hack7/widgets/exchange_box.dart';
import 'package:hack7/widgets/title_view.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
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

    listViews.add(
      TitleView(
        titleTxt: 'Current Exchange',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 0, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      ExchangeBox(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 2, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    // listViews.add(
    //   AccountsHeader(
    //     titleTxt: 'My Accounts',
    //     subTxt: 'Add Account',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve: const Interval((1 / count) * 0, 1.0,
    //             curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //     onGoBack: onGoBack,
    //   ),
    // );

    listViews.add(AccountTypes(
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: widget.animationController!,
          curve:
              const Interval((1 / 10) * 7, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: widget.animationController!,
      onGoBack: onGoBack,
    ));

    // listViews.add(AccountTileList(
    //   animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //       parent: widget.animationController!,
    //       curve:
    //           const Interval((1 / 10) * 7, 1.0, curve: Curves.fastOutSlowIn))),
    //   animationController: widget.animationController!,
    //   onGoBack: onGoBack,
    // ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  FutureOr onGoBack(dynamic value) {
    widget.animationController!.forward();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
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
    );
  }

  Widget getMainListViewUI() {
    var web3 = Provider.of<Web3EthProvider>(context, listen: false);
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.mainBlue,
            ),
          );
        } else {
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
              if (listViews.length > 4) {
                if (index == 3) {
                  return const SizedBox();
                }
                widget.animationController?.forward();
                return listViews[index];
              } else {
                widget.animationController?.forward();
                return listViews[index];
              }
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
          animation: widget.animationController!,
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
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Home',
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
                            // FutureBuilder(builder: )
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      // widget.animationController!
                                      //     .reverse()
                                      //     .then((value) {
                                      //   // Navigator.of(context).pushNamed(
                                      //   //     PaymentRequestScreen.routename);
                                      // });
                                    },
                                    icon: const Icon(
                                      Icons.request_quote_outlined,
                                      size: 35,
                                      // color: ,
                                    )),
                                FutureBuilder(
                                    future: Provider.of<Web3EthProvider>(
                                            context,
                                            listen: false)
                                        .getPaymentRequests(
                                            Provider.of<AuthService>(context,
                                                    listen: false)
                                                .loggedInUser
                                                .vpa),
                                    builder: ((ct, snapshot) {
                                      if (snapshot.hasData) {
                                        return Positioned(
                                          right: 8,
                                          top: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(2.0),
                                            // color: Theme.of(context).accentColor,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.red,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              (snapshot.data.length).toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox(
                                        height: 0,
                                        width: 0,
                                      );
                                    }))
                              ],
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
