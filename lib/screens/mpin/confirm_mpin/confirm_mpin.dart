/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_bloc.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_event.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_state.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/screens/signup/signup.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmMpin extends StatefulWidget {
  final String mpin;
  const ConfirmMpin({Key? key, required this.mpin}) : super(key: key);

  @override
  _ConfirmMpinState createState() => _ConfirmMpinState();
}

class _ConfirmMpinState extends State<ConfirmMpin> {
  String confirmMpin = "";
  StreamController<ErrorAnimationType>? confirmMpinErrorController;
  TextEditingController confirmMpinEditingController = TextEditingController();

  @override
  void initState() {
    confirmMpinErrorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: BlocProvider(
        create: (context) => ConfirmMpinBloc(),
        child: BlocConsumer<ConfirmMpinBloc, ConfirmMpinState>(
          listener: (context, state) {
            if (state is ConfirmMpinValidState) {
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
            var mpinError = '';
            if (state is ConfirmMpinErrorState) {
              mpinError = state.mpinError;
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
                          content(mpinError),
                          const SizedBox(height: 5),
                          button(context, state),
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
    return PreLoginToolbar("Confirm", () {
      Navigator.pop(context);
    });
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

  Widget content(String mpinError) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Confirm 4 digit M-PIN",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
            errorAnimationController: confirmMpinErrorController,
            controller: confirmMpinEditingController,
            keyboardType: TextInputType.number,
            boxShadows: const [
              BoxShadow(
                offset: Offset(0.1, 0.1),
                color: Colors.white,
                blurRadius: 3,
              )
            ],
            onCompleted: (v) {
              confirmMpin = v;
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
    );
  }

  Widget button(BuildContext context, ConfirmMpinState state) {
    return GradientButton("Create M-PIN", () {
      BlocProvider.of<ConfirmMpinBloc>(context)
          .add(ConfirmMpinSubmittedEvent(widget.mpin, confirmMpin));
    }, isLoading: (state is ConfirmMpinLoadingState) ? true : false);
  }
}
