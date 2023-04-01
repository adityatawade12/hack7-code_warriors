import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack7/screens/accounts/primary_account_screen.dart';
import 'package:hack7/screens/profile/edit_profile.dart';
import 'package:hack7/screens/splash_screen.dart';
import 'package:hack7/screens/auth/login_screen.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/auth/singup_screen.dart';
import 'package:hack7/screens/home.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Web3Provider())
      //   ChangeNotifierProvider(create: (ctx) => Web3Api()),
      //   ChangeNotifierProvider(create: (ctx) => AuthService()),
      //   ChangeNotifierProvider(create: (ctx) => DbService())
      ],
      child: MaterialApp(
        title: 'App Name',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
        ),
        initialRoute: SplashScreen.routename,
        routes: {
          LoginScreen.routename: (ctx) => const LoginScreen(),
          SignUpScreen.routename: (ctx) => SignUpScreen(),
          SplashScreen.routename: (ctx) => SplashScreen(),
          EditProfile.routename: (ctx) => EditProfile(),
          PrimaryAccountScreen.routename: (ctx) => const PrimaryAccountScreen(),
          HomeScreen.routename: (ctx) => const HomeScreen()
        },
      )
    );
  }
}

/* 
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
} */