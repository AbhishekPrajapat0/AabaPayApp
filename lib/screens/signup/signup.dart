/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:aabapay_app/screens/login/bloc/login_bloc.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/otp_verification/otp_verification.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_bloc.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_event.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_state.dart';
import 'package:aabapay_app/widgets/dropdowns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/toolbar.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController mobileEditingController = TextEditingController();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pincodeEditingController = TextEditingController();

  var referenceErrorMessage = '';
  String referenceValue = 'FRIEND';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpValidState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => OtpVerification(
                        mobile: state.mobile,
                        createMpin: true,
                        forgotMpinFlag: false)),
              );
            }
          },
          builder: (context, state) {
            var firstNameError = '';
            var lastNameError = '';
            var mobileError = '';
            var emailError = '';
            var pincodeError = '';

            if (state is SignUpErrorState) {
              firstNameError = state.firstNameErrorMessage;
              lastNameError = state.lastNameErrorMessage;
              mobileError = state.mobileErrorMessage;
              emailError = state.emailErrorMessage;
              pincodeError = state.pincodeErrorMessage;
            }
            return SafeArea(
              bottom: true,
              top: true,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        PreLoginToolbar("Sign Up", () {
                          Navigator.of(context).pop();
                        }),
                        const SizedBox(height: 25),
                        BorderedTextField(
                            "First Name", firstNameEditingController,
                            capital: AppConstants.CAPTIAL_WORDS,
                            errorMsg: firstNameError),
                        const SizedBox(height: 20),
                        BorderedTextField(
                            "Last Name", lastNameEditingController,
                            capital: AppConstants.CAPTIAL_WORDS,
                            errorMsg: lastNameError),
                        const SizedBox(height: 20),
                        BorderedTextField(
                            "Mobile Number", mobileEditingController,
                            textInputType: TextInputType.phone,
                            errorMsg: mobileError),
                        const SizedBox(height: 20),
                        BorderedTextField("E-mail", emailEditingController,
                            textInputType: TextInputType.emailAddress,
                            errorMsg: emailError),
                        const SizedBox(height: 20),
                        BorderedTextField("Pin Code", pincodeEditingController,
                            textInputType: TextInputType.number,
                            errorMsg: pincodeError),
                        const SizedBox(height: 20),
                        reference(),
                        const SizedBox(height: 40),
                        GradientButton("Sign Up", () {
                          BlocProvider.of<SignUpBloc>(context).add(
                              SignUpSubmittedEvent(
                                  firstNameEditingController.text,
                                  lastNameEditingController.text,
                                  mobileEditingController.text,
                                  emailEditingController.text,
                                  pincodeEditingController.text,
                                  referenceValue));
                        },
                            isLoading:
                                (state is SignUpLoadingState) ? true : false),
                        const SizedBox(height: 40),
                        RichText(
                            text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: darkPrimaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Login(forgotMpinFlag: false)),
                                        (Route<dynamic> route) => false);
                                  },
                              ),
                            ])),
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

  Widget reference() {
    List<DropdownMenuItem<String>> referenceItems = [
      const DropdownMenuItem(
        value: 'FRIEND',
        child: Text('Friend'),
      ),
      const DropdownMenuItem(
        value: 'YOUTUBE',
        child: Text('YouTube'),
      ),
      const DropdownMenuItem(
        value: 'FACEBOOK',
        child: Text('Facebook'),
      ),
      const DropdownMenuItem(
        value: 'WHATSAPP',
        child: Text('Whatsapp'),
      ),
      const DropdownMenuItem(
        value: 'OTHERS',
        child: Text('Others'),
      ),
    ];
    return FloatingDropdownString('Reference', referenceItems, referenceValue,
        (value) {
      setState(() {
        referenceValue = value!;
      });
    }, referenceErrorMessage);
  }
}
