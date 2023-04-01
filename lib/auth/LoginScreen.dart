import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routename = '/login';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        height: 10,
        width: 10,
        color: Colors.blue,
      ),
    );
  }
}
