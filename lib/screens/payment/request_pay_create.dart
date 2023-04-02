// import 'dart:html';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/account/account_dialog.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:hack7/widgets/gradientIcon.dart';
import 'package:provider/provider.dart';

class CreatePayRequestScreen extends StatefulWidget {
  const CreatePayRequestScreen({Key? key}) : super(key: key);
  static const routename = '/createPayRequest';

  @override
  State<CreatePayRequestScreen> createState() => _CreatePayRequestScreenState();
}

class _CreatePayRequestScreenState extends State<CreatePayRequestScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationController;
  List<Widget> listViews = <Widget>[];

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
      CreatePayRequestWidget(
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
      // Container(
      //  decoration: const BoxDecoration(
      //       gradient: LinearGradient(colors: [
      //         // HexColor('#6A88E5'),
      //         AppTheme.nearlyBlue,
      //         AppTheme.mainBlue,
      //         AppTheme.nearlyBlue
      //       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      //       ),
      child: Scaffold(
        // appBar: AppBar(
        //   title: getAppBarUI(),
        //   backgroundColor: AppTheme.background,
        //   foregroundColor: AppTheme.darkText,
        //   elevation: 0,
        // ),
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
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
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
                                  'Create Pay Request',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20 + 6 - 6 * topBarOpacity,
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

class CreatePayRequestWidget extends StatefulWidget {
  const CreatePayRequestWidget(
      {Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<CreatePayRequestWidget> createState() => _CreatePayRequestWidgetState();
}

class _CreatePayRequestWidgetState extends State<CreatePayRequestWidget> {
  final _formKey = GlobalKey<FormState>();
  final vpaController = TextEditingController();
  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  final payController = TextEditingController();
  bool validVpa = true;
  String _selectedType = "eth";
  @override
  Widget build(BuildContext context) {
    Web3EthProvider web3 = Web3EthProvider();
    var address = ModalRoute.of(context)!.settings.arguments;
    print(address);
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
                            Icons.request_quote_rounded,
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
                          Text(
                            "Amount:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 40,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(minWidth: 40),
                                child: IntrinsicWidth(
                                  child: TextFormField(
                                    controller: payController,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0"),
                                    style: TextStyle(fontSize: 30),
                                    onChanged: (value) {
                                      print(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppTextField(
                            controller: vpaController,
                            hint: "VPA Id",
                            icon: Icons.account_balance_wallet_outlined,
                            validator: ((value) {
                              if (value!.isEmpty || value == '') {
                                return "vpa cannot be empty";
                              }
                            }),
                          ),
                          const SizedBox(
                            height: 10,
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
                          validVpa
                              ? SizedBox(
                                  height: 16,
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Invalid VPA",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.red),
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
                                if (_formKey.currentState!.validate() &&
                                    payController.text.length != 0) {
                                  var dbs = Provider.of<DbProvider>(context,
                                      listen: false);
                                  if (await dbs.checkVPAValidityForPayment(
                                      vpaController.text, _selectedType)) {
                                    /* await Provider.of<Web3EthProvider>(context,
                                            listen: false)
                                        .createPaymentRequest(
                                            int.parse(payController.text),
                                            address,
                                            vpaController.text); */
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    print("stat");
                                    Timer timer =
                                        Timer(Duration(milliseconds: 3000), () {
                                      int count = 0;
                                      Navigator.of(context, rootNavigator: true)
                                          .popUntil(((_) => count++ >= 2));
                                    });
                                    print("before");
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                            "Request Created successfully"),
                                      ),
                                    ).then((value) {
                                      timer.cancel();
                                      // timer = null;
                                    });
                                    print("after");
                                    setState(() {});
                                  } else {
                                    setState(() {
                                      validVpa = false;
                                    });
                                  }
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Request",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )),
                        ],
                      ),

                      // NewWidget(nameController: nameController, pin1Controller: pin1Controller, pin2Controller: pin2Controller, formKey: _formKey, web3: web3)
                    ),
                  ))),
        );
      },
    );
    // );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
    required this.nameController,
    required this.pin1Controller,
    required this.pin2Controller,
    required GlobalKey<FormState> formKey,
    required this.web3,
  })  : _formKey = formKey,
        super(key: key);

  final TextEditingController nameController;
  final TextEditingController pin1Controller;
  final TextEditingController pin2Controller;
  final GlobalKey<FormState> _formKey;
  final Web3EthProvider web3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          "New Account",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 47,
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Account Name", border: OutlineInputBorder()),
          controller: nameController,
          validator: ((value) {
            if (value!.length == 0 || value == '') {
              return "Name cannot be empty";
            }
          }),
        ),
        const SizedBox(
          height: 35,
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Enter Security PIN", border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          obscureText: true,
          maxLength: 4,
          controller: pin1Controller,
          validator: (value) {
            if (value!.length != 4) {
              print(value);
              return "Pin Should Be 4 digits long";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Re-enter Security PIN", border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          obscureText: true,
          maxLength: 4,
          controller: pin2Controller,
          validator: (value) {
            if (value!.length != 4) {
              return "Pin Should Be 4 digits long";
            }
            if (pin1Controller.text != pin2Controller.text) {
              return "PIN does not match";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppTheme.mainBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ))),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var accountData = await web3.createNewAccount(
                    nameController.text, pin1Controller.text, "eth");
                showDialog(
                    context: context,
                    builder: (ctx) => AccountDialog(accountData.name,
                        accountData.accountAddress, accountData.privateKey));
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Create",
                style: TextStyle(fontSize: 20),
              ),
            )),
        const Spacer(),
      ],
    );
  }
}
