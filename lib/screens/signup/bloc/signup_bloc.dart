/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/signup/bloc/signup_api.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_event.dart';
import 'package:aabapay_app/screens/signup/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpApi signUpApi = SignUpApi();

  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpSubmittedEvent>((event, emit) async {
      emit(SignUpLoadingState());
      await signUpApi
          .register(event.firstName, event.lastName, event.mobile, event.email,
              event.pincode, event.reference)
          .then((value) {
        String firstNameError = '';
        String lastNameError = '';
        String mobileError = '';
        String emailError = '';
        String pincodeError = '';
        String referenceError = '';
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
            if (k == 'mobile') {
              mobileError = error;
            }
            if (k == 'email') {
              emailError = error;
            }
            if (k == 'pincode') {
              pincodeError = error;
            }
            if (k == 'reference') {
              referenceError = error;
            }
          });
        }
        if (firstNameError == '' &&
            lastNameError == '' &&
            mobileError == '' &&
            emailError == '' &&
            pincodeError == '' &&
            referenceError == '') {
          emit(SignUpValidState(event.mobile));
        }
        emit(SignUpErrorState(firstNameError, lastNameError, mobileError,
            emailError, pincodeError, referenceError));
      });
    });
  }
}
