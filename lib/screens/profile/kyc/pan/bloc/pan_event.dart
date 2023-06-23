/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class PanEvent {}

class PanLoadEvent extends PanEvent {}

class PanNumberSubmittedEvent extends PanEvent {
  final String number;
  PanNumberSubmittedEvent(this.number);
}

class PanErrorEvent extends PanEvent {
  final String numberError;
  final String photoError;
  PanErrorEvent(this.numberError, this.photoError);
}

class PanPhotoSubmittedEvent extends PanEvent {
  String panBase64Image;
  PanPhotoSubmittedEvent(this.panBase64Image);
}
