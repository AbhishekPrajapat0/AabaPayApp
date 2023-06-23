/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class PanState {}

class PanInitialState extends PanState {}

class PanLoadingState extends PanState {}

class PanLoadedState extends PanState {}

class PanNumberSubmittedState extends PanState {}

class PanPhotoSubmittedState extends PanState {}

class PanNumberVerifiedState extends PanState {}

class PanErrorState extends PanState {
  final String numberError;
  final String photoError;
  PanErrorState(this.numberError, this.photoError);
}

class PanPhotoUploadedState extends PanState {
  late final XFile? panPhoto;
  PanPhotoUploadedState(this.panPhoto);
}

class PanPhotoVerifiedState extends PanState {}
