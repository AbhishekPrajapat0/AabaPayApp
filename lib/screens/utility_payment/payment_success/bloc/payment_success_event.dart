/* Tushar Ugale * Technicul.com */
abstract class PaymentSuccessEvent {}

class PaymentSuccessLoadEvent extends PaymentSuccessEvent {
  String? orderId;
  String? paymentId;
  PaymentSuccessLoadEvent(this.orderId, this.paymentId);
}
