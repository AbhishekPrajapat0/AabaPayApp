/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/login/bloc/login_event.dart';
import 'package:aabapay_app/screens/login/bloc/login_state.dart';
import 'package:aabapay_app/screens/login/bloc/login_bloc.dart';
import 'package:aabapay_app/screens/otp_verification/otp_verification.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/toolbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_bloc.dart';
import 'package:aabapay_app/screens/signup/signup.dart';

class Login extends StatefulWidget {
  final bool forgotMpinFlag;
  const Login({Key? key, required this.forgotMpinFlag}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginValidState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => OtpVerification(
                        mobile: state.mobile,
                        createMpin: false,
                        forgotMpinFlag: widget.forgotMpinFlag)),
              );
            }
          },
          builder: (context, state) {
            var errorMessage = '';
            if (state is LoginErrorState) {
              errorMessage = state.mobileErrorMessage;
            }
            return SafeArea(
              bottom: true,
              top: true,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        (widget.forgotMpinFlag == false
                            ? PreLoginToolbar("Log in", () {
                                Navigator.pop(context);
                              }, showBlackButton: false)
                            : PreLoginToolbar("Forgot M-PIN", () {
                                Navigator.pop(context);
                              }, showBlackButton: false)),
                        const SizedBox(height: 60),
                        SvgPicture.asset(
                          "assets/images/logo.svg",
                          height: 80,
                          width: 80,
                        ),
                        const SizedBox(height: 20),
                        const Text("Aaba Pay",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 36)),
                        const SizedBox(height: 40),
                        BorderedTextField(
                            "Mobile Number", mobileEditingController,
                            textInputType: TextInputType.phone,
                            errorMsg: errorMessage,
                            autoFocus: true),
                        const SizedBox(height: 40),
                        GradientButton("Request OTP", () {
                          BlocProvider.of<LoginBloc>(context).add(
                              LoginSubmittedEvent(
                                  mobileEditingController.text));
                        },
                            isLoading:
                                (state is LoginLoadingState) ? true : false),
                        const SizedBox(height: 20),
                        const Text(
                          "A 6 digit OTP will be sent via SMS to verify your\nmobile number",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        (widget.forgotMpinFlag == false
                            ? RichText(
                                text: TextSpan(
                                    text: 'New User? ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    children: [
                                    TextSpan(
                                      text: 'Create an Account',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: darkPrimaryColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                        },
                                    ),
                                  ]))
                            : Text('')),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
