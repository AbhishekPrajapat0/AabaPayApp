/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_state.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_event.dart';
import 'package:aabapay_app/screens/profile/kyc/kyc.dart';

class AadharCheckOTP extends StatefulWidget {
  @override
  _AadharCheckOTPState createState() => _AadharCheckOTPState();
}

class _AadharCheckOTPState extends State<AadharCheckOTP> {
  final AadharCheckOTPBloc _aadharCheckOTPBloc = AadharCheckOTPBloc();
  TextEditingController otpController = TextEditingController();
  String otpError = '';

  @override
  void initState() {
    _aadharCheckOTPBloc.add(AadharCheckOTPLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 3,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)),
              (Route<dynamic> route) => false),
        ),
        title: const Text("Aadhar Verify OTP",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _aadharCheckOTPBloc,
          child: BlocListener<AadharCheckOTPBloc, AadharCheckOTPState>(
            listener: (context, state) {
              if (state is AadharCheckOTPValidState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Kyc()),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<AadharCheckOTPBloc, AadharCheckOTPState>(
              builder: (context, state) {
                if (state is AadharCheckOTPErrorState) {
                  otpError = state.otpError;
                }
                if (state is AadharCheckOTPInitialState ||
                    state is AadharCheckOTPLoadingState) {
                  return _buildLoading();
                } else {
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, AadharCheckOTPState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            SizedBox(height: 10),
            otpField(),
            SizedBox(height: 5),
            Text(
              otpError,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30),
            submitOTP(context, state),
          ])),
    );
  }

  Widget otpField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BorderedTextField('Enter OTP', otpController,
              textInputType: TextInputType.number),
        ),
      ],
    );
  }

  Widget submitOTP(BuildContext context, AadharCheckOTPState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        child: GradientButton("Verify with OTP", () {
          BlocProvider.of<AadharCheckOTPBloc>(context)
              .add(AadharCheckOTPSubmittedEvent(
            otpController.text,
          ));
        }, isLoading: (state is AadharCheckOTPSubmittedState) ? true : false),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
