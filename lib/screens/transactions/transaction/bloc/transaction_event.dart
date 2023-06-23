/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/models/priority.dart';

abstract class TransactionEvent {}

class TransactionLoadEvent extends TransactionEvent {
  int orderId;
  TransactionLoadEvent(this.orderId);
}

class TransactionConfirmPriorityEvent extends TransactionEvent {
  Priority priority;
  Order order;
  TransactionConfirmPriorityEvent(this.priority, this.order);
}
