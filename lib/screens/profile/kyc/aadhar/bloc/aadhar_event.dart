/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class AadharEvent {}

class AadharLoadEvent extends AadharEvent {}

class AadharNumberSubmittedEvent extends AadharEvent {
  final String number;
  AadharNumberSubmittedEvent(this.number);
}

class AadharErrorEvent extends AadharEvent {
  final String numberError;
  final String photoError;
  AadharErrorEvent(this.numberError, this.photoError);
}

class AadharPhotoSubmittedEvent extends AadharEvent {
  String frontBase64Image;
  String backBase64Image;
  AadharPhotoSubmittedEvent(this.frontBase64Image, this.backBase64Image);
}
