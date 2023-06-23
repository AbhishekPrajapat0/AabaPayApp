/* Tushar Ugale * Technicul.com */
import 'package:image_picker/image_picker.dart';

abstract class PhotoEvent {}

class PhotoLoadEvent extends PhotoEvent {}

class PhotoSubmittedEvent extends PhotoEvent {
  final String photo;
  PhotoSubmittedEvent(this.photo);
}

class PhotoErrorEvent extends PhotoEvent {
  final String photoError;
  PhotoErrorEvent(this.photoError);
}
