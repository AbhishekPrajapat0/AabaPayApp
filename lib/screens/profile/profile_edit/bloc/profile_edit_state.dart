/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';

abstract class ProfileEditState {}

class ProfileEditInitialState extends ProfileEditState {}

class ProfileEditLoadingState extends ProfileEditState {}

class ProfileEditLoadedState extends ProfileEditState {
  User user;
  ProfileEditLoadedState(this.user);
}

class ProfileEditErrorState extends ProfileEditState {
  final String firstNameErrorMessage;
  final String lastNameErrorMessage;
  final String emailErrorMessage;
  final String pincodeErrorMessage;
  ProfileEditErrorState(
    this.firstNameErrorMessage,
    this.lastNameErrorMessage,
    this.emailErrorMessage,
    this.pincodeErrorMessage,
  );
}

class ProfileEditUpdatedState extends ProfileEditState {}
