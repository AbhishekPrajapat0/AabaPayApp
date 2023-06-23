/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/payment_option.dart';
import 'package:aabapay_app/models/payment_option_category.dart';
import 'package:aabapay_app/screens/utility_payment/payment_options/bloc/payment_options_event.dart';
import 'package:aabapay_app/screens/utility_payment/payment_options/bloc/payment_options_state.dart';
import 'package:aabapay_app/screens/utility_payment/payment_options/bloc/payment_options_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentOptionsBloc
    extends Bloc<PaymentOptionsEvent, PaymentOptionsState> {
  final PaymentOptionsApi paymentOptionsApi = PaymentOptionsApi();

  PaymentOptionsBloc() : super(PaymentOptionsInitialState()) {
    on<PaymentOptionsLoadEvent>((event, emit) async {
      await paymentOptionsApi.paymentOptions().then((value) {
        print(value['data'][0]['payment_options']);
        List<PaymentOptionCategory> paymentOptionsCategories =
            List<PaymentOptionCategory>.from(value['data']
                    .map((model) => PaymentOptionCategory.fromJson(model)))
                .toList();
        emit(PaymentOptionsLoadedState(paymentOptionsCategories));
      });
    });

    on<PaymentOptionsChangeEvent>((event, emit) async {
      await paymentOptionsApi
          .paymentOptionCalculation(
        event.payment.beneficiaryId,
        event.payment.purposeId,
        event.payment.transactionAmount,
        event.payment.receivableAmount,
        event.payment.convenienceCharges,
        event.payment.gst,
        event.payment.total,
        event.payment.bearer,
        event.payment.priorityId,
        event.paymentOption,
      )
          .then((value) {
        Payment payment = Payment.fromJson(value);
        emit(
            PaymentOptionsChangedState(payment, event.paymentOptionCategories));
      });
    });

    on<PaymentOptionsNewOrderEvent>((event, emit) async {
      emit(PaymentOptionsNewOrderLoadingState(
          event.payment, event.paymentOptionCategories, event.paymentOption));
      await paymentOptionsApi.paymentStore(event.payment).then((value) {
        if (value['payment_gateway_key'] != null &&
            value['order_id'] != null &&
            value['amount'] != null &&
            value['currency'] != null &&
            value['user_mobile'] != null) {
          emit(PaymentOptionsNewOrderCreatedState(
              event.payment,
              event.paymentOptionCategories,
              event.paymentOption,
              value['payment_gateway_key'],
              value['order_id'],
              value['amount'],
              value['currency'],
              value['user_mobile']));
        }
      });
    });
  }
}
