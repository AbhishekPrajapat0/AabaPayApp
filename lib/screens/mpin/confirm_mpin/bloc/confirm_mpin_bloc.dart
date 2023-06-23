/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_api.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_event.dart';
import 'package:aabapay_app/screens/mpin/confirm_mpin/bloc/confirm_mpin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmMpinBloc extends Bloc<ConfirmMpinEvent, ConfirmMpinState> {
  final ConfirmMpinApi confirmMpinApi = ConfirmMpinApi();

  ConfirmMpinBloc() : super(ConfirmMpinInitialState()) {
    on<ConfirmMpinSubmittedEvent>((event, emit) async {
      emit(ConfirmMpinLoadingState());
      await confirmMpinApi
          .createMpin(event.mpin, event.confirmMpin)
          .then((value) async {
        String mpinError = '';
        String confirmMpinError = '';
        if (value['errors'] != null) {
          value['errors'].forEach((k, v) {
            var error;
            if (v.runtimeType == String) {
              error = v.toString();
            } else {
              error = v[0].toString();
            }

            if (k == 'm_pin') {
              mpinError += error;
            }
            if (k == 'confirm_m_pin') {
              mpinError += error;
            }
          });
        }

        if (mpinError != '') {
          emit(ConfirmMpinErrorState(mpinError));
        }
        if (value['message'] == "M-PIN set succesfully") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('mpin', value['mpin']);
          emit(ConfirmMpinValidState());
        }
      });
    });
  }
}
