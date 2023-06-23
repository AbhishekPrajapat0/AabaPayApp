/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  User user;
  ProfileLoadedState(this.user);
}

class ProfileAccountDeletedState extends ProfileState {}
