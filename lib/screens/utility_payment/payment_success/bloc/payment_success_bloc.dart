/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/payment_option.dart';
import 'package:aabapay_app/models/payment_option_category.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_event.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_state.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSuccessBloc
    extends Bloc<PaymentSuccessEvent, PaymentSuccessState> {
  final PaymentSuccessApi paymentSuccessApi = PaymentSuccessApi();

  PaymentSuccessBloc() : super(PaymentSuccessInitialState()) {
    on<PaymentSuccessLoadEvent>((event, emit) async {
      await paymentSuccessApi
          .paymentSuccess(event.orderId, event.paymentId)
          .then((value) {
        if (value['message'].toString().toLowerCase() ==
            'Payment Success added successfully'.toLowerCase()) {
          Order order = Order.fromJson(value['order']);
          emit(PaymentSuccessLoadedState(order));
        }
      });
    });
  }
}
