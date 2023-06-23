/* Tushar Ugale * Technicul.com */
abstract class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String mobile;
  LoginSubmittedEvent(this.mobile);
}
