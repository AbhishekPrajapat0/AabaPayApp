/* Tushar Ugale * Technicul.com */
abstract class OtpVerificationState {}

class OtpVerificationInitialState extends OtpVerificationState {}

class OtpVerificationValidState extends OtpVerificationState {}

class OtpVerificationErrorState extends OtpVerificationState {
  final String otpErrorMessage;
  OtpVerificationErrorState(this.otpErrorMessage);
}

class OtpVerificationLoadingState extends OtpVerificationState {}
