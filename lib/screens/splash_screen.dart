import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/screens/accounts/add_accounts_screen.dart';
import 'package:hack7/screens/home.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    var auth = Provider.of<AuthService>(context, listen: false);

    if (auth.currentUser == 0) {
      Timer(const Duration(seconds: 4),
          () => Navigator.pushReplacementNamed(context, LoginScreen.routename));
    } else {
      auth.getUserData().then((value) async {
        Timer(
            const Duration(seconds: 1),
            () =>
                Navigator.pushReplacementNamed(context, HomeScreen.routename));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Spacer(),
          SizedBox(
            height: 80,
            width: 80,
            child: Image.asset("assets/images/logo.png"),
          ),
          const Spacer(),
          const Text(
            "BitFinance",
            style: TextStyle(fontSize: 25),
          ),
          const Spacer(),
        ],
      ),
    ));
  }
}
