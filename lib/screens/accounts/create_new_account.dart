// import 'dart:html';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/themes/homeapptheme.dart';
import 'package:hack7/widgets/account/account_dialog.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:hack7/widgets/gradientIcon.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  static const routename = '/createAccount';

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
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
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

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
      CreateAccountWidget(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval((1 / count) * 2, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    animationController!.forward();
    setState(() {});
  }

  @override
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("loading page");
    }
    return GestureDetector(
      onDoubleTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: HomeAppTheme.background,
        body: Stack(
          children: <Widget>[
            Center(child: getMainListViewUI()),
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
    return ListView.builder(
      shrinkWrap: true,
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
                    color: HomeAppTheme.background,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: HomeAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  size: 25,
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: HomeAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: HomeAppTheme.darkerText,
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

class CreateAccountWidget extends StatefulWidget {
  CreateAccountWidget({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  String _selectedType = 'eth';
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.animation!.value), 0.0),
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    // height: 800,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: GradientIcon(
                            Icons.person_add_alt_rounded,
                            90.0,
                            const LinearGradient(
                              colors: [AppTheme.mainBlue, AppTheme.nearlyBlue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          )),
                          const SizedBox(
                            height: 30,
                          ),
                          AppTextField(
                            controller: nameController,
                            hint: "Account name",
                            icon: Icons.person_outlined,
                            validator: ((value) {
                              if (value!.isEmpty || value == '') {
                                return "Name cannot be empty";
                              }
                            }),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppTextField(
                            controller: pin1Controller,
                            hint: "Enter Security PIN",
                            isPassword: true,
                            icon: Icons.pin_outlined,
                            keyboardType: TextInputType.number,
                            validator: ((value) {
                              if (value!.length != 4) {
                                print(value);
                                return "Pin Should Be 4 digits long";
                              }
                              return null;
                            }),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppTextField(
                            controller: pin2Controller,
                            hint: "Re-enter Security PIN",
                            isPassword: true,
                            keyboardType: TextInputType.number,
                            icon: Icons.pin_outlined,
                            validator: ((value) {
                              if (value!.length != 4) {
                                return "Pin Should Be 4 digits long";
                              }
                              if (pin1Controller.text != pin2Controller.text) {
                                return "PIN does not match";
                              }
                              return null;
                            }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 70,
                            width: 250,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedType = 'eth';
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Radio(
                                            value: 'eth',
                                            groupValue: _selectedType,
                                            onChanged: (value) {}),
                                        Text("ETH"),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedType = 'sol';
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Radio(
                                            value: 'sol',
                                            groupValue: _selectedType,
                                            onChanged: (value) {}),
                                        Text("SOL"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppTheme.mainBlue),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                  ))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var accountData;
                                  if (_selectedType == "eth") {
                                    accountData =
                                        await Provider.of<Web3EthProvider>(
                                                context,
                                                listen: false)
                                            .createNewAccount(
                                                nameController.text,
                                                pin1Controller.text,
                                                "eth");
                                  } else {
                                    accountData =
                                        await Provider.of<Web3SolProvider>(
                                                context,
                                                listen: false)
                                            .createNewAccount(
                                                nameController.text,
                                                pin1Controller.text,
                                                "sol");
                                  }
                                  // var accountData =
                                  //     await Provider.of<Web3EthProvider>(
                                  //             context)
                                  //         .createNewAccount(nameController.text,
                                  //             pin1Controller.text, 'eth');
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AccountDialog(
                                          accountData.name,
                                          accountData.accountAddress,
                                          accountData.privateKey));
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Create",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ))),
        );
      },
    );
    // );
  }
}
