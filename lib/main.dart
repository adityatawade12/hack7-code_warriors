import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hack7/screens/SplashScreen.dart';
import 'package:hack7/screens/account/AddAccountsScreen.dart';
import 'package:hack7/screens/auth/login_screen.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.initFlutter(directory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Web3EthProvider()),
          ChangeNotifierProvider(create: (ctx) => Web3SolProvider())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: HomeScreen.routename,
          routes: {
            LoginScreen.routename: (ctx) => LoginScreen(),
            SplashScreen.routename: (ctx) => SplashScreen(),
            AddAccountScreen.routename: (ctx) => AddAccountScreen(),
            HomeScreen.routename: (ctx) => const HomeScreen()
          },
        ));
  }
}
