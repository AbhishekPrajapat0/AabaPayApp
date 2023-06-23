/* Tushar Ugale * Technicul.com */
abstract class AadharCheckOTPEvent {}

class AadharCheckOTPLoadEvent extends AadharCheckOTPEvent {}

class AadharCheckOTPSubmittedEvent extends AadharCheckOTPEvent {
  final String otp;
  AadharCheckOTPSubmittedEvent(this.otp);
}
