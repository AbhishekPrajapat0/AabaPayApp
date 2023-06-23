/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_api.dart';
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_event.dart';
import 'package:aabapay_app/screens/otp_verification/bloc/otp_verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final OtpVerificationApi otpVerificationApi = OtpVerificationApi();

  OtpVerificationBloc() : super(OtpVerificationInitialState()) {
    on<OtpVerificationSubmittedEvent>((event, emit) async {
      emit(OtpVerificationLoadingState());
      await otpVerificationApi.verifyOtp(event.mobile, event.otp).then((value) {
        String otpError = '';
        if (value['message'] != null) {
          if (value['message'] == 'User logged in successfully') {
            emit(OtpVerificationValidState());
          } else {
            otpError = value['message'];
            emit(OtpVerificationErrorState(otpError));
          }
        }
      });
    });
  }
}
