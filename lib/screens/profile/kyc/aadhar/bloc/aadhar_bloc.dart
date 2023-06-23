/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_event.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_state.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AadharBloc extends Bloc<AadharEvent, AadharState> {
  final AadharApi aadharApi = AadharApi();

  AadharBloc() : super(AadharInitialState()) {
    on<AadharLoadEvent>((event, emit) async {
      emit(AadharLoadedState());
    });

    on<AadharErrorEvent>((event, emit) async {
      emit(AadharErrorState(event.numberError, event.photoError));
    });

    on<AadharNumberSubmittedEvent>((event, emit) async {
      emit(AadharNumberSubmittedState());
      await aadharApi.sendAadharOtp(event.number).then((value) {
        if (value['message'] == 'OTP Sent Successfully') {
          emit(AadharNumberVerifiedState());
        } else {
          String numberError = value['message'];
          String photoError = '';
          emit(AadharErrorState(numberError, photoError));
        }
      });
    });

    on<AadharPhotoSubmittedEvent>((event, emit) async {
      emit(AadharPhotoSubmittedState());
      await aadharApi
          .sendAadharPhotos(event.frontBase64Image, event.backBase64Image)
          .then((value) {
        if (value['message'] == 'Aadhar Photo Verified') {
          emit(AadharPhotoVerifiedState());
        } else {
          String numberError = '';
          String photoError = value['message'];
          emit(AadharErrorState(numberError, photoError));
        }
      });
    });
  }
}
