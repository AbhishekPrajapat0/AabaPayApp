/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/payment_option_category.dart';

abstract class PaymentOptionsEvent {}

class PaymentOptionsLoadEvent extends PaymentOptionsEvent {}

class PaymentOptionsChangeEvent extends PaymentOptionsEvent {
  Payment payment;
  List<PaymentOptionCategory> paymentOptionCategories;
  int paymentOption;
  PaymentOptionsChangeEvent(
      this.payment, this.paymentOptionCategories, this.paymentOption);
}

class PaymentOptionsNewOrderEvent extends PaymentOptionsEvent {
  Payment payment;
  List<PaymentOptionCategory> paymentOptionCategories;
  int paymentOption;
  PaymentOptionsNewOrderEvent(
      this.payment, this.paymentOptionCategories, this.paymentOption);
}

class PaymentOptionsPaymentSuccessEvent extends PaymentOptionsEvent {
  String? orderId;
  String? paymentId;
  PaymentOptionsPaymentSuccessEvent(this.orderId, this.paymentId);
}
