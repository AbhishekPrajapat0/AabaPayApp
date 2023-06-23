/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_event.dart';
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_state.dart';
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final ProfileEditApi profileEditApi = ProfileEditApi();

  ProfileEditBloc() : super(ProfileEditInitialState()) {
    on<ProfileEditLoadEvent>((event, emit) async {
      emit(ProfileEditLoadedState(event.user));
    });

    on<ProfileEditSubmittedEvent>((event, emit) async {
      await profileEditApi
          .updateProfile(
              event.firstName, event.lastName, event.email, event.pincode)
          .then((value) {
        print(event.pincode);
        String firstNameError = '';
        String lastNameError = '';
        String emailError = '';
        String pincodeError = '';
        if (value['errors'] != null) {
          value['errors'].forEach((k, v) {
            var error;
            if (v.runtimeType == String) {
              error = v.toString();
            } else {
              error = v[0].toString();
            }

            if (k == 'first_name') {
              firstNameError = error;
            }
            if (k == 'last_name') {
              lastNameError = error;
            }
            if (k == 'email') {
              emailError = error;
            }
            if (k == 'pincode') {
              pincodeError = error;
            }
          });
        }

        if (firstNameError != '' ||
            lastNameError != '' ||
            emailError != '' ||
            pincodeError != '') {
          emit(ProfileEditErrorState(
              firstNameError, lastNameError, emailError, pincodeError));
        } else {
          emit(ProfileEditUpdatedState());
        }
      });
    });
  }
}
