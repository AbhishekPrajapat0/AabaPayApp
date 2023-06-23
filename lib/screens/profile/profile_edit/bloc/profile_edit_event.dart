/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';

abstract class ProfileEditEvent {}

class ProfileEditLoadEvent extends ProfileEditEvent {
  User user;
  ProfileEditLoadEvent(this.user);
}

class ProfileEditSubmittedEvent extends ProfileEditEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String pincode;
  ProfileEditSubmittedEvent(
      this.firstName, this.lastName, this.email, this.pincode);
}
