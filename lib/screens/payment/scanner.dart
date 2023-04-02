import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/title_view.dart';
import 'pay_screen.dart';

import 'dart:async';

// import 'createAccountScreen.dart';
// import 'importAccountScreen.dart';

class CamScanScreen extends StatefulWidget {
  static const routename = '/scan';
  // final String address;
  // final Map<String, dynamic> trns;
  // final String address;
  // final String currEx;
  const CamScanScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CamScanScreenState createState() => _CamScanScreenState();
}

class _CamScanScreenState extends State<CamScanScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationController;
  List<Widget> listViews = <Widget>[];

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool validVPA = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

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
    listViews.add(const SizedBox(
      height: 100,
    ));

    listViews.add(
      CamScanWidget(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval((1 / count) * 2, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: animationController!,
        onGoBack: onGoBack,
      ),
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
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("loading page");
    return Container(
      child: Scaffold(
        // backgroundColor: AppTheme.nearlyDarkBlue,
        backgroundColor: AppTheme.background,
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
                                  'Send Money',
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

class CamScanWidget extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final onGoBack;

  const CamScanWidget({
    Key? key,
    this.animationController,
    this.animation,
    this.onGoBack,
  }) : super(key: key);

  @override
  State<CamScanWidget> createState() => _CamScanWidgetState();
}

class _CamScanWidgetState extends State<CamScanWidget> {
  final vpaController = TextEditingController();
  bool validVpa = true;

  Future _scanQR() async {
    try {
      String? cameraScanResult = await scanner.scan();
      // setState(() {
      //   scanresult =
      //       cameraScanResult!; // setting string result with cameraScanResult
      // });
      var address = "";
      var name = "";
      var parsedJson = json.decode(cameraScanResult!);
      var vpa = "";
      if (parsedJson['mode'] == "vpa") {
        var result;
        if (parsedJson['type'] == "eth") {
          result = await Provider.of<DbProvider>(context, listen: false)
              .getVPA(parsedJson['value'], "eth");
        } else {
          result = await Provider.of<DbProvider>(context, listen: false)
              .getVPA(parsedJson['value'], "sol");
        }

        address = result["address"]!;
        name = result["name"]!;
        vpa = parsedJson['value'];
      } else {
        address = parsedJson['value'];
        name = await Provider.of<DbProvider>(context, listen: false)
            .getAccountname(address, parsedJson['type']);
        vpa = " ";
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => PayScreen(address, name, vpa, parsedJson['type'])));
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _selectedType = "eth";
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.animation!.value), 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // InkWell(
                  //     child: GridTile(
                  //       child: Container(
                  //         decoration: const BoxDecoration(
                  //             borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(3.0),
                  //                 bottomLeft: Radius.circular(8.0),
                  //                 bottomRight: Radius.circular(8.0),
                  //                 topRight: Radius.circular(68.0)),
                  //             // color: Colors.blue,
                  //             gradient: LinearGradient(
                  //                 colors: [
                  //                   Color.fromRGBO(68, 72, 214, 1),
                  //                   AppTheme.nearlyBlue
                  //                 ],
                  //                 begin: Alignment.topCenter,
                  //                 end: Alignment.bottomCenter)),
                  //         width: 150,
                  //         height: 150,
                  //         child: Center(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: const [
                  //               Icon(
                  //                 Icons.add,
                  //                 size: 70,
                  //                 color: Colors.white,
                  //               ),
                  //               Text(
                  //                 "New",
                  //                 style: TextStyle(
                  //                     fontSize: 21, color: Colors.white),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       widget.animationController!.reverse().then((value) {
                  //         // Navigator.pushNamed(
                  //         //         context, CreateAccountScreen.routename)
                  //         //     .then(widget.onGoBack);
                  //       });
                  //     }),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     AppTextField(
                  //         controller: vpaController,
                  //         hint: "Enter VPA",
                  //         icon: Icons.account_balance_wallet_rounded),
                  //     SizedBox(
                  //       height: 10,
                  //       width: 10,
                  //     )
                  //   ],
                  // ),
                  const SizedBox(
                    height: 30,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 260,
                          child: AppTextField(
                              controller: vpaController,
                              hint: "Enter VPA",
                              icon: Icons.account_balance_wallet_rounded),
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
                        InkWell(
                          onTap: () async {
                            var dbs =
                                Provider.of<DbProvider>(context, listen: false);
                            if (await dbs.checkVPAValidityForPayment(
                                vpaController.text, _selectedType)) {
                              var result = await Provider.of<DbProvider>(
                                      context,
                                      listen: false)
                                  .getVPA(vpaController.text, _selectedType);
                              //  var address = ;
                              //   var name = result["name"]!;
                              //   var vpa = vpaController.text;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PayScreen(
                                      result["address"]!,
                                      result["name"]!,
                                      vpaController.text,
                                      _selectedType)));
                            } else {
                              setState(() {
                                validVpa = false;
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(68, 72, 214, 1),
                                        AppTheme.nearlyBlue
                                      ]),
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.arrow_forward_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  validVpa
                      ? const SizedBox(
                          height: 16,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Invalid VPA",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: 100,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "OR",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: 100,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: GridTile(
                      // footer: Text("Create"),
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            // color: Colors.blue,
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(68, 72, 214, 1),
                                  AppTheme.nearlyBlue
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        width: 150,
                        height: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.qr_code_scanner_outlined,
                                size: 70,
                                color: Colors.white,
                              ),
                              Text(
                                "Scan",
                                style: TextStyle(
                                    fontSize: 21, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      var status = await Permission.camera.status;
                      if (status.isDenied) {
                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                        await Permission.camera.request();
                        // print("Permission is denined.");
                      } else if (status.isGranted) {
                        //permission is already granted.
                        // print("Permission is already granted.");
                      } else if (status.isPermanentlyDenied) {
                        //permission is permanently denied.
                        await Permission.camera.request();
                        // print("Permission is permanently denied");
                      } else if (status.isRestricted) {
                        //permission is OS restricted.
                        // print("Permission is OS restricted.");
                      }
                      _scanQR();
                    },
                  ),
                ],
              )),
        );
      },
    );
  }
}

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     Key? key,
//     required this.animationController,
//     required this.onGoBack,
//   }) : super(key: key);

//   final AnimationController? animationController;
//   final var onGoBack;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         InkWell(
//             child: GridTile(
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(3.0),
//                         bottomLeft: Radius.circular(8.0),
//                         bottomRight: Radius.circular(8.0),
//                         topRight: Radius.circular(68.0)),
//                     // color: Colors.blue,
//                     gradient: LinearGradient(
//                         colors: [
//                           AppTheme.nearlyDarkBlue,
//                           HexColor("#6F56E8")
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter)),
//                 width: 150,
//                 height: 150,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.add,
//                         size: 70,
//                         color: Colors.white,
//                       ),
//                       Text(
//                         "Create",
//                         style: TextStyle(
//                             fontSize: 21, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               animationController!.reverse().then((value) {
//                 Navigator.pushNamed(
//                         context, CreateAccountScreen.routename)
//                     .then(onGoBack);
//               });
//             }),
//         SizedBox(
//           height: 30,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               color: Colors.black,
//               height: 1,
//               width: 100,
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             const Text(
//               "OR",
//               style: TextStyle(fontSize: 30),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Container(
//               color: Colors.black,
//               height: 1,
//               width: 100,
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//         InkWell(
//           child: GridTile(
//             // footer: Text("Create"),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8.0),
//                       bottomLeft: Radius.circular(68.0),
//                       bottomRight: Radius.circular(3.0),
//                       topRight: Radius.circular(8.0)),
//                   // color: Colors.blue,
//                   gradient: LinearGradient(
//                       colors: [
//                         AppTheme.nearlyDarkBlue,
//                         HexColor("#6F56E8")
//                       ],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter)),
//               width: 150,
//               height: 150,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(
//                       Icons.file_download_outlined,
//                       size: 70,
//                       color: Colors.white,
//                     ),
//                     Text(
//                       "Import",
//                       style: TextStyle(
//                           fontSize: 21, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           onTap: () {
//             animationController!.reverse().then((value) {
//               Navigator.pushNamed(
//                       context, ImportAccountScreen.routename)
//                   .then(onGoBack);
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

// class CamScan extends StatefulWidget {
//   CamScan({Key? key}) : super(key: key);
//   static const routename = '/scanner';

//   // final AnimationController? animationController;

//   @override
//   State<CamScan> createState() => _CamScanState();
// }

// class _CamScanState extends State<CamScan> with TickerProviderStateMixin {
//   final ScrollController scrollController = ScrollController();

//   // Animation<double>? topBarAnimation;

//   // final ScrollController scrollController = ScrollController();
//   // double topBarOpacity = 0.0;

//   List<Widget> listViews = <Widget>[];
//   List<Widget> listViewsEmpty = <Widget>[];
//   List<Widget> listViewsFilled = <Widget>[];

//   late String scanresult;

//   @override
//   void initState() {
//     // topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//     //   CurvedAnimation(
//     //       parent: widget.animationController!,
//     //       curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn))
//     // );
//     scanresult = "none"; //innical value of scan result is "none"
//     addAllListData();

//     super.initState();
//   }

//   void addAllListData() {
//     const int count = 10;

//     listViews.add(
//       RichText(
//         text: TextSpan(
//           text: 'Scan QR Code',
//           style: TextStyle(
//             fontSize: 35,
//             color: AppTheme.darkerText,
//           ),
//         ),
//       ),
//     );
//   }

//   Future _scanQR() async {
//     try {
//       String? cameraScanResult = await scanner.scan();
//       // setState(() {
//       //   scanresult =
//       //       cameraScanResult!; // setting string result with cameraScanResult
//       // });
//       var address = "";
//       var name = "";
//       var parsedJson = json.decode(cameraScanResult!);
//       var vpa = "";
//       if (parsedJson['mode'] == "vpa") {
//         var result = await Provider.of<DbService>(context, listen: false)
//             .getVPA(parsedJson['value']) as Map<String, String>;
//         address = result["address"]!;
//         name = result["name"]!;
//         vpa = parsedJson['value'];
//       } else {
//         address = parsedJson['value'];
//         name = await Provider.of<DbService>(context, listen: false)
//             .getAccountname(address);
//         vpa = "";
//       }

//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (ctx) => PayScreen(address, name, vpa)));
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }

//   // @override
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppTheme.background,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: <Widget>[
//             getMainListViewUI(),
//             getAppBarUI(),
//             scannWid(context),
//             SizedBox(
//               height: MediaQuery.of(context).padding.bottom,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget scannWid(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: double.infinity,
//           ),
//           Text("Result:" + scanresult),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//               onPressed: () async {
//                 var status = await Permission.camera.status;
//                 if (status.isDenied) {
//                   // We didn't ask for permission yet or the permission has been denied before but not permanently.
//                   await Permission.camera.request();
//                   print("Permission is denined.");
//                 } else if (status.isGranted) {
//                   //permission is already granted.
//                   print("Permission is already granted.");
//                 } else if (status.isPermanentlyDenied) {
//                   //permission is permanently denied.
//                   await Permission.camera.request();
//                   print("Permission is permanently denied");
//                 } else if (status.isRestricted) {
//                   //permission is OS restricted.
//                   print("Permission is OS restricted.");
//                 }
//                 _scanQR();
//               },
//               child: Text("Scan"))
//         ],
//       ),
//     );
//   }

//   Widget getMainListViewUI() {
//     var web3 = Provider.of<Web3Api>(context, listen: false);

//     // return FutureBuilder(
//     //   future: web3.fetchStoredAccounts(),
//     //   builder: (BuildContext context, snapshot) {
//     return ListView.builder(
//       controller: scrollController,
//       padding: EdgeInsets.only(
//         top: AppBar().preferredSize.height +
//             MediaQuery.of(context).padding.top +
//             24,
//         bottom: 62 + MediaQuery.of(context).padding.bottom,
//       ),
//       itemCount: listViews.length,
//       scrollDirection: Axis.vertical,
//       itemBuilder: (BuildContext context, int index) {
//         // if (listViews.length > 4) {
//         //   if (index == 3) {
//         //     return SizedBox();
//         //   }
//         //   widget.animationController?.forward();
//         //   return listViews[index];
//         // } else {
//         // widget.animationController?.forward();
//         return listViews[index];
//         // }
//       },
//     );
//     // }
//     // },
//     // );
//   }

//   Widget getAppBarUI() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppTheme.white.withOpacity(1),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(32.0),
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//               color: AppTheme.grey.withOpacity(0.4 * 1),
//               offset: const Offset(1.1, 1.1),
//               blurRadius: 10.0),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: MediaQuery.of(context).padding.top,
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//                 left: 16, right: 16, top: 16 - 8.0, bottom: 12 - 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Home',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontFamily: AppTheme.fontName,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 22 + 6 - 6,
//                         letterSpacing: 1.2,
//                         color: AppTheme.darkerText,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
