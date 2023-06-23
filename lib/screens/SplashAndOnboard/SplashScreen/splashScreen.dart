/* Tushar Ugale * Technicul.com */
import 'dart:async';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/screens/SplashAndOnboard/OnBoardSlidingItem/OnBoarding/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 900),
          child: const OnBoard(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Shimmer.fromColors(
            baseColor: lightPrimaryColor,
            highlightColor: Colors.blue,
            direction: ShimmerDirection.ltr,
            period: const Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: 120,
              ),
            ),
          )
              // Image.asset(
              //   'assets/images/logo.png',
              //   height: 120,
              // ),
              ),
          const SizedBox(height: 10),
          Image.asset(
            "assets/images/Textlogo.png",
            height: 40,
          ),
        ],
      ),
    );
  }
}
