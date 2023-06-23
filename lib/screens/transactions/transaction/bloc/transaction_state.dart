/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/models/priority.dart';

abstract class TransactionState {}

class TransactionInitialState extends TransactionState {}

class TransactionValidState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  Order order;
  List<Priority> priorities;
  TransactionLoadedState(this.order, this.priorities);
}
