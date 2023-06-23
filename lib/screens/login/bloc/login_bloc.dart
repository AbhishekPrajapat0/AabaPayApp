/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/login/bloc/login_api.dart';
import 'package:aabapay_app/screens/login/bloc/login_event.dart';
import 'package:aabapay_app/screens/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginApi loginApi = LoginApi();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmittedEvent>((event, emit) async {
      emit(LoginLoadingState());
      await loginApi.login(event.mobile).then((value) {
        String mobile = '';
        if (value['message'] != null) {
          if (value['message'] == 'OTP Sent succesfully') {
            emit(LoginValidState(event.mobile));
          } else {
            mobile = value['message'];
          }
        }

        if (value['errors'] != null) {
          value['errors'].forEach((k, v) {
            var error;
            if (v.runtimeType == String) {
              error = v.toString();
            } else {
              error = v[0].toString();
            }

            if (k == 'mobile') {
              mobile = error;
            }
          });
        }

        emit(LoginErrorState(mobile));
      });
    });
  }
}
