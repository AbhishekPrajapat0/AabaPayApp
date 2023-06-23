/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_api.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_event.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsApi transactionsApi = TransactionsApi();

  TransactionsBloc() : super(TransactionsInitialState()) {
    on<TransactionsLoadEvent>((event, emit) async {
      await transactionsApi.getTransactions().then((value) {
        List<Order> orders =
            List<Order>.from(value.map((model) => Order.fromJson(model)))
                .toList();
        for (Order or in orders) {
          print('-----');
          print(or.status);
        }
        emit(TransactionsLoadedState(orders, ''));
      });
    });

    on<SearchTransactionsEvent>((event, emit) async {
      await transactionsApi.searchTransactions(event.searchQuery).then((value) {
        List<Order> orders =
            List<Order>.from(value.map((model) => Order.fromJson(model)))
                .toList();
        emit(TransactionsLoadedState(orders, ''));
      });
    });

    on<TransactionsFilterEvent>((event, emit) async {
      await transactionsApi.getTransactions().then((value) {
        List<Order> orders =
            List<Order>.from(value.map((model) => Order.fromJson(model)))
                .toList();
        List<Order> finalOrders = [];
        for (Order order in orders) {
          if (event.filterValue == '') {
            finalOrders.add(order);
          }
          if (event.filterValue != '') {
            if (order.status == event.filterValue) {
              finalOrders.add(order);
            }
          }
        }
        emit(TransactionsLoadedState(finalOrders, event.filterValue));
      });
    });
  }
}
