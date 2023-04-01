import 'package:flutter/material.dart';
import 'package:hack7/screens/SplashScreen.dart';
import 'package:hack7/screens/account/AddAccountsScreen.dart';
import 'package:hack7/screens/auth/login_screen.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (ctx) => Web3Provider())],
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
