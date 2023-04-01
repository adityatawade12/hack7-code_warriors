import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/ApptextField.dart';

class LoginScreen extends StatefulWidget {
  static const routename = '/login';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool signup = false;
  GlobalKey _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool invalidCreds = false;

  _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(68, 72, 214, 1), AppTheme.nearlyBlue])),
    );
  }

  errorWidget(invalidCred) {
    if (invalidCreds) {
      return [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Invalid Credentials!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        )
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    return GestureDetector(
      child: Scaffold(
        body: Stack(children: [
          _backgroundGradient(),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: mq.size.height,
              ),
              child: SafeArea(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // RichText(
                        //   text:
                        const Text(
                          'BitFinance',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                        // ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        AppTextField(
                            controller: emailController,
                            hint: "Enter Email",
                            icon: Icons.mail),
                        SizedBox(
                          height: 25,
                        ),
                        AppTextField(
                            controller: passController,
                            hint: "Password",
                            icon: Icons.password),
                        ...errorWidget(invalidCreds),
                        const SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(68, 72, 214, 1),
                              fixedSize: const Size(70, 45),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            child: Text("Login"),
                            onPressed: () {},
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                child: const Text("Sign up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onTap: () {
                                  print("Sign up");
                                  Navigator.pushNamed(
                                      context, LoginScreen.routename);
                                },
                              )
                            ])
                      ],
                    ),
                    Spacer()
                  ],
                ),
              )),
            ),
          )
        ]),
      ),
      onDoubleTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }
}
