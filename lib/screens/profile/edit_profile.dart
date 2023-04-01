import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);
  static const routename = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  bool signup = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();
  final nameController = TextEditingController();
  final vpaController = TextEditingController();

  bool _isChecking = false;
  dynamic _validationMsg;

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

  _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(68, 72, 214, 1), AppTheme.nearlyBlue])),
    );
  }

  Future<dynamic> checkVPA(vpa) async {
    _validationMsg = null;
    setState(() {});

    //do all sync validation
    if (vpa.isEmpty) {
      _validationMsg = "VPA is required";
      setState(() {});
      // return "VPA is required";
    }

    // do async validation

    _isChecking = true;
    setState(() {});
    //it's just faking delay, make your won async validation here
    // await Future.delayed(Duration(seconds: 2));
    var availableVPA =
        await Provider.of<DbProvider>(context, listen: false).checkVPA(vpa);
    _isChecking = false;
    print(availableVPA);
    if (availableVPA == "0") {
      _validationMsg = "$vpa is taken";
    }

    // if (vpa != 'harun') ;

    setState(() {});
  }

  
  void addAllListData() {
    const int count = 10;

    listViews.add(
      EditProfileWidget(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController!,
          curve: const Interval((1 / count) * 2, 1.0,
            curve: Curves.fastOutSlowIn
          )
        )),
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
          body: GestureDetector(
            onDoubleTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Stack(
              children: <Widget>[
                _backgroundGradient(),
                Center(child: getMainListViewUI()),
                getAppBarUI(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          )),
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
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
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
                                  color: AppTheme.nearlyWhite,
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Edit Profile',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.nearlyWhite,
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

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final vpaController = TextEditingController();
  Timer? _timerVpa = Timer(const Duration(milliseconds: 0), () {});
  bool vpaExist = false;
  String ogVpa = "";

  @override
  void initState() {

    var auth = Provider.of<AuthService>(context, listen: false);
    ogVpa = auth.loggedInUser.vpa;
    nameController.text = auth.loggedInUser.name;
    vpaController.text = auth.loggedInUser.vpa;

    vpaController.addListener(() async {
      if (vpaController.text != ogVpa) {
        if (_timerVpa!.isActive) {
          _timerVpa?.cancel();
        }
        _timerVpa = Timer(const Duration(milliseconds: 500), (() async {
          var vpaex = await Provider.of<DbProvider>(context, listen: false)
              .checkVPAValidity(vpaController.text);
          print("Changing vap status" + vpaex.toString() + vpaController.text);
          setState(() {
            if (vpaex == "0") {
              print("--");
              vpaExist = true;
            } else {
              print("++");

              vpaExist = false;
            }
          });
          print(vpaExist);
        }));
      }
    });
//  */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Web3EthProvider web3 = Web3EthProvider();
    var auth = Provider.of<AuthService>(context);

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.animation!.value), 0.0),
              child: Center(
                // height: 800,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Icon(
                                  Icons.mode_edit_rounded,
                                    size: 80.0,
                                    color: AppTheme.nearlyWhite,
                                  )
                                        // child: GradientIcon(
                                        //   Icons.mode_edit_rounded,
                                        //   90.0,
                                        //   const LinearGradient(
                                        //     colors: [AppTheme.nearlyWhite, AppTheme.nearlyBlue],
                                        //     begin: Alignment.topCenter,
                                        //     end: Alignment.bottomCenter,
                                        //   ),
                                        // )
                                        ),
                              const SizedBox(
                                height: 30,
                              ),
                              AppTextField(
                                controller: nameController,
                                hint: "Enter name",
                                icon: Icons.person_outlined,
                              ),
                              const SizedBox(height: 30),
                              AppTextField(
                                  controller: vpaController,
                                  hint: "Enter VPA",
                                  icon: Icons.dns_outlined,
                                ),
                              vpaExist? Row(
                                children: const [
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 15
                                    ),
                                    child: Text(
                                      "VPA already taken",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppTheme.mainBlue),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                )
                              )
                            ),
                            onPressed: () async {
                              if (nameController.text.isNotEmpty && !vpaExist) {
                                var stat = await auth.updateAccountInfo(
                                        nameController.text,
                                        vpaController.text);
                                print("edit");
                                print(stat);
                                if (stat == "1") {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus
                                      .hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  print("stat");
                                  Timer timer = Timer(
                                      const Duration(milliseconds: 3000),
                                      () {
                                    Navigator.of(context,
                                            rootNavigator: true)
                                        .pop();
                                  });
                                  print("before");
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const AlertDialog(
                                      title: Text(
                                          "Account updated successfully"),
                                    ),
                                  ).then((value) {
                                    timer.cancel();
                                    // timer = null;
                                  });
                                  print("after");
                                  setState(() {});
                                }
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ),
                        ],
                      )
                    )
                  )
                )
              ),
            )
          ),
        );
      },
    );
  }
}
