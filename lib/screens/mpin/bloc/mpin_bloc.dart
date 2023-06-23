/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/mpin/bloc/mpin_api.dart';
import 'package:aabapay_app/screens/mpin/bloc/mpin_event.dart';
import 'package:aabapay_app/screens/mpin/bloc/mpin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MpinBloc extends Bloc<MpinEvent, MpinState> {
  final MpinApi mpinApi = MpinApi();

  MpinBloc() : super(MpinInitialState()) {}
}
