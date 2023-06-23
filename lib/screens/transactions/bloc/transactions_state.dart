/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';

abstract class TransactionsState {}

class TransactionsInitialState extends TransactionsState {}

class TransactionsValidState extends TransactionsState {}

class TransactionsLoadingState extends TransactionsState {}

class TransactionsLoadedState extends TransactionsState {
  List<Order> orders;
  String filterValue;
  TransactionsLoadedState(this.orders, this.filterValue);
}
