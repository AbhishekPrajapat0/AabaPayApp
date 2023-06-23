/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/mpin/mpin.dart';
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_bloc.dart';
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_event.dart';
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_state.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/screens/signup/signup.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerification extends StatefulWidget {
  final String mobile;
  final bool createMpin;
  final bool forgotMpinFlag;
  OtpVerification(
      {Key? key,
      required this.mobile,
      required this.createMpin,
      required this.forgotMpinFlag})
      : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification>
    with TickerProviderStateMixin {
  String otp = "";
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 10);
  bool _showTimer = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: BlocProvider(
        create: (context) => OtpVerificationBloc(),
        child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
          listener: (context, state) {
            if (state is OtpVerificationValidState) {
              if (widget.createMpin == true) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Mpin()),
                    (Route<dynamic> route) => false);
              } else if (widget.forgotMpinFlag == true) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Mpin()),
                    (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Home(
                            selectedIndex: 0,
                            profileUpdatedFlag: false,
                            feedbackAddedFlag: false)),
                    (Route<dynamic> route) => false);
              }
            }
          },
          builder: (context, state) {
            var otpErrorMessage = '';
            String strDigits(int n) => n.toString().padLeft(2, '0');
            final minutes = strDigits(myDuration.inMinutes.remainder(60));
            final seconds = strDigits(myDuration.inSeconds.remainder(60));
            if (state is OtpVerificationErrorState) {
              otpErrorMessage = state.otpErrorMessage;
            }
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
                          content(otpErrorMessage),
                          const SizedBox(height: 5),
                          button(context, state),
                          const SizedBox(height: 20),
                          subContent(minutes, seconds),
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
        Text('OTP Verification',
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

  Widget content(String otpErrorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter 6 digit OTP",
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
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: PinCodeTextField(
            autoFocus: true,
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            length: 6,
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
              fieldWidth: 40,
            ),
            cursorColor: Colors.white,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            keyboardType: TextInputType.number,
            boxShadows: const [
              BoxShadow(
                offset: Offset(0.1, 0.1),
                color: Colors.white,
                blurRadius: 3,
              )
            ],
            onCompleted: (v) {
              otp = v;
            },
            onChanged: (value) {},
            beforeTextPaste: (text) {
              return true;
            },
          ),
        ),
        Text(
          otpErrorMessage,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget button(BuildContext context, OtpVerificationState state) {
    return GradientButton("Verify OTP", () {
      BlocProvider.of<OtpVerificationBloc>(context)
          .add(OtpVerificationSubmittedEvent(widget.mobile, otp));
    }, isLoading: (state is OtpVerificationLoadingState) ? true : false);
  }

  Widget subContent(String minutes, String seconds) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Did\'nt receive OTP?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            )),
        SizedBox(height: 5),
        (_showTimer
            ? Text(
                minutes + ':' + seconds,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white),
              )
            : GestureDetector(
                onTap: () {
                  startTimer();
                  setState(() {
                    _showTimer = true;
                    Timer(Duration(seconds: 10), () {
                      resetTimer();
                      setState(() {
                        _showTimer = false;
                      });
                    });
                  });
                },
                child: Text('Resend OTP',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: darkPrimaryColor)),
              )),
      ],
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(seconds: 10));
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }
}
