import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hack7/models/tab_icon_data.dart';
import 'package:hack7/screens/accounts/account_screen.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/bottombar.dart';


class HomeScreen extends StatefulWidget {
  static const routename = "/home";

  const HomeScreen({super.key});
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = AccountScreen(animationController: animationController);

    ///
    ///notif
    if (kDebugMode) {
      print("running initstate");
    }

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  FutureOr onGoBack(dynamic value) {
    animationController!.forward();
    // setState(() {});
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            animationController?.reverse().then((value) {
              // Navigator.pushNamed(context, CamScanScreen.routename)
              //     .then(onGoBack);
            });
            // Navigator.push(context, CamScan(animationController: animationController));
          },
          changeIndex: (int index) {
            if (kDebugMode) {
              print("Index is: $index");
            }
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                    AccountScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                // setState(() {
                  // tabBody =
                  //     ProfileScreen(animationController: animationController);
                // });
              });
            }
          },
        ),
      ],
    );
  }
}
