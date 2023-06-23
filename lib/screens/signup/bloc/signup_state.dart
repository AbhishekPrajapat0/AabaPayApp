/* Tushar Ugale * Technicul.com */
abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpValidState extends SignUpState {
  final String mobile;
  SignUpValidState(this.mobile);
}

class SignUpErrorState extends SignUpState {
  final String firstNameErrorMessage;
  final String lastNameErrorMessage;
  final String mobileErrorMessage;
  final String emailErrorMessage;
  final String pincodeErrorMessage;
  final String referenceErrorMessage;
  SignUpErrorState(
      this.firstNameErrorMessage,
      this.lastNameErrorMessage,
      this.mobileErrorMessage,
      this.emailErrorMessage,
      this.pincodeErrorMessage,
      this.referenceErrorMessage);
}

class SignUpLoadingState extends SignUpState {}
