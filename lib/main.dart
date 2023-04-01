import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/screens/account/AddAccountsScreen.dart';
import 'package:hack7/screens/accounts/primary_account_screen.dart';
import 'package:hack7/screens/profile/edit_profile.dart';
import 'package:hack7/screens/splash_screen.dart';
import 'package:hack7/screens/auth/login_screen.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/auth/singup_screen.dart';
import 'package:hack7/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.initFlutter(directory.path);
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
          ChangeNotifierProvider(create: (ctx) => AuthService()),
          ChangeNotifierProvider(create: (ctx) => DbProvider()),
          ChangeNotifierProvider(create: (ctx) => Web3EthProvider()),
          ChangeNotifierProvider(create: (ctx) => Web3SolProvider())
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
            PrimaryAccountScreen.routename: (ctx) =>
                const PrimaryAccountScreen(),
            HomeScreen.routename: (ctx) => const HomeScreen(),
            AddAccountScreen.routename: (ctx) => const AddAccountScreen()
          },

          
        ));
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
