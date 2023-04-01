import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/account/account_dialog.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:hack7/widgets/gradientIcon.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qrscan/qrscan.dart' as scanner;



class ImportAccountScreen extends StatefulWidget {
  ImportAccountScreen({Key? key}) : super(key: key);
  static const routename = '/importAccount';

  @override
  State<ImportAccountScreen> createState() => _ImportAccountScreenState();
}

class _ImportAccountScreenState extends State<ImportAccountScreen>
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
//
    listViews.add(
      ImportAccountWidget(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
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
    return Container(
      decoration: const BoxDecoration(
          // gradient: LinearGradient(colors: [
          //   // HexColor('#6A88E5'),
          //   AppTheme.nearlyBlue,
          //   AppTheme.mainBlue,
          //   AppTheme.nearlyBlue
          // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
      child: Scaffold(
        // backgroundColor: AppTheme.mainBlue,
        backgroundColor: AppTheme.background,
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
    // var db = Provider.of<DbService>(context, listen: false);
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
                    color: AppTheme.background,
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
                                  'Import Account',
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

class ImportAccountWidget extends StatefulWidget {
  ImportAccountWidget({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<ImportAccountWidget> createState() => _ImportAccountWidgetState();
}

class _ImportAccountWidgetState extends State<ImportAccountWidget> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  final pkController = TextEditingController();

  Future _scanQR() async {
    try {
      String? cameraScanResult = await scanner.scan();
      print(cameraScanResult);
      // Navigator.pushNamed(context, ImportAccountScreen.routename,
      //     arguments: cameraScanResult);
      setState(() {
        pkController.text = cameraScanResult!;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Web3EthProvider web3 = Web3EthProvider();
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.animation!.value), 0.0),
              child: Center(
                // height: 800,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Form(
                        key: _formKey,
                        child: Center(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: GradientIcon(
                                      Icons.import_export_rounded,
                                      90.0,
                                      const LinearGradient(
                                        colors: [
                                          AppTheme.mainBlue,
                                          AppTheme.nearlyBlue
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AppTextField(
                                      controller: nameController,
                                      hint: "Account Name",
                                      // isPassword: true,
                                      icon: Icons.person_outlined,
                                      // keyboardType: TextInputType.number,
                                      validator: ((value) {
                                        if (value!.length == 0 || value == '') {
                                          return "Name cannot be empty";
                                        }
                                      }),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            controller: pkController,
                                            hint: "Private Key",
                                            // isPassword: true,
                                            icon: Icons.key_rounded,
                                            keyboardType:
                                                TextInputType.multiline,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          68, 72, 214, 1),
                                                      AppTheme.nearlyBlue
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            height: 50,
                                            width: 50,
                                            child: const Icon(
                                              Icons.qr_code_scanner_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () async {
                                            var status =
                                                await Permission.camera.status;
                                            if (status.isDenied) {
                                              // We didn't ask for permission yet or the permission has been denied before but not permanently.
                                              await Permission.camera.request();
                                              print("Permission is denined.");
                                            } else if (status.isGranted) {
                                              //permission is already granted.
                                              print(
                                                  "Permission is already granted.");
                                            } else if (status
                                                .isPermanentlyDenied) {
                                              //permission is permanently denied.
                                              await Permission.camera.request();
                                              print(
                                                  "Permission is permanently denied");
                                            } else if (status.isRestricted) {
                                              //permission is OS restricted.
                                              print(
                                                  "Permission is OS restricted.");
                                            }
                                            _scanQR();
                                          },
                                        )
                                      ],
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
                                      hint: 'Re-enter Security PIN',
                                      keyboardType: TextInputType.number,
                                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      isPassword: true,
                                      icon: Icons.pin_outlined,
                                      // maxLength: 4,
                                      controller: pin2Controller,
                                      validator: (value) {
                                        if (value!.length != 4) {
                                          return "Pin Should Be 4 digits long";
                                        }
                                        if (pin1Controller.text !=
                                            pin2Controller.text) {
                                          return "PIN does not match";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppTheme.mainBlue),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                            ))),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var accountData =
                                                await web3.importAccount(
                                                    nameController.text,
                                                    pin1Controller.text,
                                                    pkController.text,
                                                    "eth");
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
                                            "Import",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )),
                                  ],
                                ))))),
              )),
        );
      },
    );
    // );
  }
}
