import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/screens/account/AddAccountsScreen.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routename = '/splash';
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 4),
        () => Navigator.pushReplacementNamed(context, LoginScreen.routename));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Spacer(),
          Container(
            height: 80,
            width: 80,
            child: Image.asset("assets/images/logo.png"),
          ),
          Spacer(),
          Text(
            "BitFinance",
            style: TextStyle(fontSize: 25),
          ),
          Spacer(),
        ],
      ),
    ));
  }
}
