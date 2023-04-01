import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/screens/auth/login_screen.dart';
import 'package:hack7/screens/home.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);
  static const routename = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool signup = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();
  final nameController = TextEditingController();
  final vpaController = TextEditingController();
  bool vpaExist = false;
  bool nameCheck = false;
  bool emailCheck = false;
  bool passCheck = false;
  Timer? _timerName = Timer(const Duration(milliseconds: 0), () {});
  Timer? _timerEmail = Timer(const Duration(milliseconds: 0), () {});
  Timer? _timerPass = Timer(const Duration(milliseconds: 0), () {});
  Timer? _timerVpa = Timer(const Duration(milliseconds: 0), () {});

  bool _isChecking = false;
  dynamic _validationMsg;

  @override
  void initState() {
    super.initState();
    vpaController.addListener(() async {
      // ignore: unnecessary_null_comparison
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
    });

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
      _validationMsg = "${vpa} is taken";
    }

    // if (vpa != 'harun') ;

    setState(() {});
  }

  errormsg(bool checker, String msg) {
    if (checker) {
      return [
        Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                msg,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ];
    }
    return [];
  }

  formValidation() {
    var x = true;
    setState(() {
      if (passController.text.length < 8) {
        passCheck = true;
      } else {
        passCheck = false;
        x = false;
      }

      if (nameController.text.length < 5) {
        nameCheck = true;
      } else {
        nameCheck = false;
        x = false;
      }
      if (emailController.text.length < 5) {
        emailCheck = true;
      } else {
        emailCheck = false;
        x = false;
      }
    });
    print("Form valid");
    print(x);
    return !x;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    var auth = Provider.of<AuthService>(context);

    return GestureDetector(
        onDoubleTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
          body: Stack(children: <Widget>[
            _backgroundGradient(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: mq.size.height,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    // Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 50,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: const TextSpan(
                                text: 'CryptoPay',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 40,),
                        Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const Text(
                                    "Sign Up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  AppTextField(
                                    controller: nameController,
                                    hint: "Enter name",
                                    icon: Icons.person_outlined,
                                  ),
                                  ...errormsg(
                                      nameCheck, "Name cannot be empty"),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    controller: emailController,
                                    hint: "Enter your email",
                                    icon: Icons.contact_mail_outlined,
                                  ),
                                  ...errormsg(emailCheck, "Invalid Email"),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    controller: passController,
                                    hint: "Enter your password",
                                    icon: Icons.password_outlined,
                                    isPassword: true,
                                  ),
                                  ...errormsg(
                                      passCheck, "Create A Stronger Password"),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    controller: vpaController,
                                    hint: "Enter VPA",
                                    icon: Icons.dns_outlined,
                                    suffix: "@cryptopay",
                                  ),
                                  ...errormsg(vpaExist, "VPA Already Taken!"),
                                  const SizedBox(height: 40),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              68, 72, 214, 1),
                                          fixedSize: const Size(70, 45),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (formValidation() && !vpaExist) {
                                            print("inside");
                                            var status = await auth.signUp(
                                                nameController.text,
                                                emailController.text,
                                                passController.text,
                                                "${vpaController.text}@cryptopay");
                                            if (status) {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(HomeScreen.routename);
                                            }
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Create Account",
                                                style: TextStyle(fontSize: 20)
                                              ),
                                      ],
                                    )
                                  )
                                ),
                              ),
                            ]
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: const Text("Already have an account?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context, LoginScreen.routename);
                              },
                            )
                          ]
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}