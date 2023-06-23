/* Tushar Ugale * Technicul.com */
abstract class SignUpEvent {}

class SignUpSubmittedEvent extends SignUpEvent {
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String pincode;
  final String reference;
  SignUpSubmittedEvent(this.firstName, this.lastName, this.mobile, this.email,
      this.pincode, this.reference);
}
