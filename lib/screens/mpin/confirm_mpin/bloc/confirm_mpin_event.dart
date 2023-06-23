/* Tushar Ugale * Technicul.com */
abstract class ConfirmMpinEvent {}

class ConfirmMpinSubmittedEvent extends ConfirmMpinEvent {
  final String mpin;
  final String confirmMpin;
  ConfirmMpinSubmittedEvent(this.mpin, this.confirmMpin);
}
