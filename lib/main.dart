/* Tushar Ugale * Technicul.com */
import 'dart:io';

import 'package:aabapay_app/screens/SplashAndOnboard/SplashScreen/splashScreen.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/login/login_mpin/login_mpin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('accessToken', '');
  if (prefs.getString('accessToken') != null &&
      prefs.getString('accessToken') != '') {
    runApp(MyHome());
  } else {
    runApp(MyLogin());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyHome extends StatelessWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: Home(
    //         selectedIndex: 0,
    //         profileUpdatedFlag: false,
    //         feedbackAddedFlag: false));

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginMpin(changeMpinFlag: false));
  }
}

class MyLogin extends StatelessWidget {
  MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     title: 'Flutter Demo',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: Login(forgotMpinFlag: false));

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}



// SizedBox(height: 20),
//               Center(
//                   child: Text(
//                 '* GST of 18% will be charged extra on convenience charges',
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               )),
//               SizedBox(height: 20),