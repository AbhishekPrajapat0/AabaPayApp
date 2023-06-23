/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_event.dart';
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_state.dart';
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanBloc extends Bloc<PanEvent, PanState> {
  final PanApi panApi = PanApi();

  PanBloc() : super(PanInitialState()) {
    on<PanLoadEvent>((event, emit) async {
      emit(PanLoadedState());
    });

    on<PanErrorEvent>((event, emit) async {
      emit(PanErrorState(event.numberError, event.photoError));
    });

    on<PanNumberSubmittedEvent>((event, emit) async {
      emit(PanNumberSubmittedState());
      await panApi.checkPanNumber(event.number).then((value) {
        if (value['message'] == 'Pan Verified Successfully') {
          emit(PanNumberVerifiedState());
        } else {
          String numberError = value['message'];
          String photoError = '';
          emit(PanErrorState(numberError, photoError));
        }
      });
    });

    on<PanPhotoSubmittedEvent>((event, emit) async {
      emit(PanPhotoSubmittedState());
      await panApi.sendPanPhoto(event.panBase64Image).then((value) {
        if (value['message'] == 'Pan Photo Verified') {
          emit(PanPhotoVerifiedState());
        } else {
          String numberError = '';
          String photoError = value['message'];
          emit(PanErrorState(numberError, photoError));
        }
      });
    });
  }
}
