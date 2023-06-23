/* Tushar Ugale * Technicul.com */
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginValidState extends LoginState {
  final String mobile;
  LoginValidState(this.mobile);
}

class LoginErrorState extends LoginState {
  final String mobileErrorMessage;
  LoginErrorState(this.mobileErrorMessage);
}

class LoginLoadingState extends LoginState {}
