/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/payment_option_category.dart';

abstract class PaymentOptionsState {}

class PaymentOptionsInitialState extends PaymentOptionsState {}

class PaymentOptionsLoadingState extends PaymentOptionsState {}

class PaymentOptionsLoadedState extends PaymentOptionsState {
  List<PaymentOptionCategory> paymentOptionCategories;
  PaymentOptionsLoadedState(this.paymentOptionCategories);
}

class PaymentOptionsChangedState extends PaymentOptionsState {
  Payment payment;
  List<PaymentOptionCategory> paymentOptionCategories;
  PaymentOptionsChangedState(this.payment, this.paymentOptionCategories);
}

class PaymentOptionsNewOrderCreatedState extends PaymentOptionsState {
  Payment payment;
  List<PaymentOptionCategory> paymentOptionCategories;
  int paymentOption;
  String paymentGatewayKey;
  String orderId;
  int amount;
  String currency;
  String userMobile;
  PaymentOptionsNewOrderCreatedState(
      this.payment,
      this.paymentOptionCategories,
      this.paymentOption,
      this.paymentGatewayKey,
      this.orderId,
      this.amount,
      this.currency,
      this.userMobile);
}

class PaymentOptionsNewOrderLoadingState extends PaymentOptionsState {
  Payment payment;
  List<PaymentOptionCategory> paymentOptionCategories;
  int paymentOption;
  PaymentOptionsNewOrderLoadingState(
    this.payment,
    this.paymentOptionCategories,
    this.paymentOption,
  );
}

class PaymentOptionsCompletedState extends PaymentOptionsState {}
