/* Tushar Ugale * Technicul.com */
abstract class OtpVerificationEvent {}

class OtpVerificationSubmittedEvent extends OtpVerificationEvent {
  final String mobile;
  final String otp;
  OtpVerificationSubmittedEvent(this.mobile, this.otp);
}
