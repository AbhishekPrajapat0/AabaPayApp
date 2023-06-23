/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class PhotoState {}

class PhotoInitialState extends PhotoState {}

class PhotoLoadingState extends PhotoState {}

class PhotoLoadedState extends PhotoState {}

class PhotoSubmittedState extends PhotoState {}

class PhotoVerifiedState extends PhotoState {}

class PhotoErrorState extends PhotoState {
  final String photoError;
  PhotoErrorState(this.photoError);
}
