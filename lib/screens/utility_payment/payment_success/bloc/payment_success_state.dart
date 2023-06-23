/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';

abstract class PaymentSuccessState {}

class PaymentSuccessInitialState extends PaymentSuccessState {}

class PaymentSuccessLoadingState extends PaymentSuccessState {}

class PaymentSuccessLoadedState extends PaymentSuccessState {
  Order order;
  PaymentSuccessLoadedState(this.order);
}
