/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/mpin/mpin.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/screens/signup/signup.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMpin extends StatefulWidget {
  final bool changeMpinFlag;
  const LoginMpin({Key? key, required this.changeMpinFlag}) : super(key: key);

  @override
  _LoginMpinState createState() => _LoginMpinState();
}

class _LoginMpinState extends State<LoginMpin> {
  String mpin = "";
  String mpinError = "";
  StreamController<ErrorAnimationType>? mpinErrorController;
  TextEditingController mpinEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    mpinErrorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackBackgroundColor,
        body: SafeArea(
          bottom: true,
          top: true,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      title(),
                      const SizedBox(height: 60),
                      logo(),
                      const SizedBox(height: 40),
                      content(),
                      const SizedBox(height: 5),
                      button(),
                      const SizedBox(height: 20),
                      subContent(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (widget.changeMpinFlag == false
            ? Text('Login With M-PIN',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 24))
            : Text('Change M-PIN',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 24))),
      ],
    );
  }

  Widget logo() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          height: 80,
          width: 80,
        ),
        const SizedBox(height: 20),
        const Text("Aaba Pay",
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white, fontSize: 36))
      ],
    );
  }

  Widget content() {
    return Column(
      children: [
        (widget.changeMpinFlag == false
            ? Text('Login with M-PIN',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16))
            : Text('Enter Your Old M-PIN',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16))),
        const SizedBox(height: 25),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: PinCodeTextField(
                autoFocus: true,
                obscureText: true,
                appContext: context,
                pastedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                length: 4,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  activeColor: blackBackgroundColor,
                  selectedColor: blackBackgroundColor,
                  inactiveColor: blackBackgroundColor,
                  activeFillColor: blackBackgroundColor,
                  selectedFillColor: blackBackgroundColor,
                  inactiveFillColor: blackBackgroundColor,
                  // errorBorderColor: blackBackgroundColor,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                ),
                cursorColor: Colors.white,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: mpinErrorController,
                controller: mpinEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0.1, 0.1),
                    color: Colors.white,
                    blurRadius: 3,
                  )
                ],
                onCompleted: (v) {
                  mpin = v;
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            Text(
              mpinError,
              style: TextStyle(color: Colors.red),
            ),
          ],
        )
      ],
    );
  }

  Widget button() {
    return Column(
      children: [
        GradientButton((widget.changeMpinFlag == false ? "Login" : "Next"),
            () async {
          setState(() {
            isLoading = true;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getString('mpin') == mpin) {
            mpinError = "";
            if (widget.changeMpinFlag == false) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Home(
                          selectedIndex: 0,
                          profileUpdatedFlag: false,
                          feedbackAddedFlag: false)),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                      child: Mpin()),
                  (Route<dynamic> route) => false);
            }
          } else {
            setState(() {
              mpinEditingController.text = '';
              mpinError = "Please enter correct M-Pin";
              isLoading = false;
            });
          }
        }, isLoading: isLoading ? true : false),
      ],
    );
  }

  Widget subContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Login(forgotMpinFlag: true)));
          },
          child: Text('Forgot your M-PIN?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: darkPrimaryColor)),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
