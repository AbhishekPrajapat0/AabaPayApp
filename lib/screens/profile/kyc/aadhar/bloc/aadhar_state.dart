/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class AadharState {}

class AadharInitialState extends AadharState {}

class AadharLoadingState extends AadharState {}

class AadharLoadedState extends AadharState {}

class AadharNumberSubmittedState extends AadharState {}

class AadharPhotoSubmittedState extends AadharState {}

class AadharNumberVerifiedState extends AadharState {}

class AadharErrorState extends AadharState {
  final String numberError;
  final String photoError;
  AadharErrorState(this.numberError, this.photoError);
}

class AadharPhotoUploadedState extends AadharState {
  late final XFile? aadharFrontPhoto;
  late final XFile? aadharBackPhoto;
  AadharPhotoUploadedState(this.aadharFrontPhoto, this.aadharBackPhoto);
}

class AadharPhotoVerifiedState extends AadharState {}
