/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_api.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_event.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionApi transactionApi = TransactionApi();

  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionLoadEvent>((event, emit) async {
      await transactionApi.getOrder(event.orderId).then((value) async {
        Order order = Order.fromJson(value);

        await transactionApi.getPriorities(event.orderId).then((value) {
          List<Priority> priorities = List<Priority>.from(
              value.map((model) => Priority.fromJson(model))).toList();

          emit(TransactionLoadedState(order, priorities));
        });
      });
    });

    on<TransactionConfirmPriorityEvent>((event, emit) async {
      await transactionApi
          .updatePriorityInOrder(event.priority, event.order)
          .then((value) {
        Order order = Order.fromJson(value['order']);
        List<Priority> priorities = List<Priority>.from(
                value['priorities'].map((model) => Priority.fromJson(model)))
            .toList();

        emit(TransactionLoadedState(order, priorities));
      });
    });
  }
}
