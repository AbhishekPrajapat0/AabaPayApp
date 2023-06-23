/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';

abstract class FeedbackPageEvent {}

class FeedbackPageLoadEvent extends FeedbackPageEvent {}

class FeedbackPageSubmittedEvent extends FeedbackPageEvent {
  final String feedback;
  final String rating;
  FeedbackPageSubmittedEvent(this.feedback, this.rating);
}
