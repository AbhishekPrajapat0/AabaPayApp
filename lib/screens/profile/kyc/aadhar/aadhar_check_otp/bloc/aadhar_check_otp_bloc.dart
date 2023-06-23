/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_event.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_state.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/bloc/aadhar_check_otp_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AadharCheckOTPBloc
    extends Bloc<AadharCheckOTPEvent, AadharCheckOTPState> {
  final AadharCheckOTPApi aadharCheckOTPApi = AadharCheckOTPApi();

  AadharCheckOTPBloc() : super(AadharCheckOTPInitialState()) {
    on<AadharCheckOTPLoadEvent>((event, emit) async {
      emit(AadharCheckOTPLoadedState());
    });

    on<AadharCheckOTPSubmittedEvent>((event, emit) async {
      emit(AadharCheckOTPSubmittedState());
      await aadharCheckOTPApi.checkAadharOtp(event.otp).then((value) {
        if (value['message'] == 'Aadhar Verified Successfully') {
          emit(AadharCheckOTPValidState());
        } else {
          String otpError = value['message'];
          emit(AadharCheckOTPErrorState(otpError));
        }
      });
    });
  }
}
