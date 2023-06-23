/* Tushar Ugale * Technicul.com */
abstract class AadharCheckOTPState {}

class AadharCheckOTPInitialState extends AadharCheckOTPState {}

class AadharCheckOTPLoadingState extends AadharCheckOTPState {}

class AadharCheckOTPLoadedState extends AadharCheckOTPState {}

class AadharCheckOTPSubmittedState extends AadharCheckOTPState {}

class AadharCheckOTPValidState extends AadharCheckOTPState {}

class AadharCheckOTPErrorState extends AadharCheckOTPState {
  String otpError;
  AadharCheckOTPErrorState(this.otpError);
}
