/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/mpin/bloc/mpin_bloc.dart';
import 'package:aabapay_app/screens/mpin/bloc/mpin_event.dart';
import 'package:aabapay_app/screens/mpin/bloc/mpin_state.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/confirm_mpin.dart';
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

class Mpin extends StatefulWidget {
  const Mpin({Key? key}) : super(key: key);

  @override
  _MpinState createState() => _MpinState();
}

class _MpinState extends State<Mpin> with TickerProviderStateMixin {
  String mpin = "";
  StreamController<ErrorAnimationType>? mpinErrorController;
  TextEditingController mpinEditingController = TextEditingController();

  @override
  void initState() {
    mpinErrorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: BlocProvider(
        create: (context) => MpinBloc(),
        child: BlocConsumer<MpinBloc, MpinState>(
          listener: (context, state) {
            if (state is MpinValidState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Home(
                          selectedIndex: 0,
                          profileUpdatedFlag: false,
                          feedbackAddedFlag: false)),
                  (Route<dynamic> route) => false);
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                          button(context, state),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Create M-PIN',
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 24)),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Enter 4 digit M-PIN",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: PinCodeTextField(
            autoFocus: true,
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
            obscureText: true,
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
      ],
    );
  }

  Widget button(BuildContext context, MpinState state) {
    return GradientButton("Next", () {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 500),
              child: ConfirmMpin(mpin: mpin)));
    }, isLoading: (state is MpinLoadingState) ? true : false);
  }
}
