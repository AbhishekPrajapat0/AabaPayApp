/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/home_page/home_page.dart';
import 'package:aabapay_app/screens/transactions/transaction/transaction.dart';
import 'package:aabapay_app/screens/utility_payment/payment_complete/payment_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_state.dart';
import 'package:aabapay_app/screens/utility_payment/payment_success/bloc/payment_success_event.dart';

class PaymentSuccess extends StatefulWidget {
  String? orderId;
  String? paymentId;
  PaymentSuccess(this.orderId, this.paymentId);
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  final PaymentSuccessBloc _paymentSuccessBloc = PaymentSuccessBloc();

  @override
  void initState() {
    _paymentSuccessBloc
        .add(PaymentSuccessLoadEvent(widget.orderId, widget.paymentId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      },
      child: BlocProvider(
        create: (_) => _paymentSuccessBloc,
        child: BlocListener<PaymentSuccessBloc, PaymentSuccessState>(
          listener: (context, state) {
            if (state is PaymentSuccessLoadedState) {
              //   Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(
              //           builder: (context) => Transaction(state.order.id)),
              //       (Route<dynamic> route) => false);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentComplete(state.order.id)),
                  (Route<dynamic> route) => false);
            }
          },
          child: BlocBuilder<PaymentSuccessBloc, PaymentSuccessState>(
            builder: (context, state) {
              return Text('');
            },
          ),
        ),
      ),
    );
  }
}

/// HANDLE PAYMENT SUCCESS - END
