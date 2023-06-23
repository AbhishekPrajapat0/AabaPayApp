/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_event.dart';
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_state.dart';
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoApi photoApi = PhotoApi();

  PhotoBloc() : super(PhotoInitialState()) {
    on<PhotoLoadEvent>((event, emit) async {
      emit(PhotoLoadedState());
    });

    on<PhotoSubmittedEvent>((event, emit) async {
      emit(PhotoSubmittedState());
      await photoApi.checkPhoto(event.photo).then((value) {
        if (value['message'] == 'Photo Verified Successfully') {
          emit(PhotoVerifiedState());
        } else {
          String photoError = value['message'];
          emit(PhotoErrorState(photoError));
        }
      });
    });
  }
}
