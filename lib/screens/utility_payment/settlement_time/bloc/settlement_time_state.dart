/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/priority.dart';

abstract class SettlementTimeState {}

class SettlementTimeInitialState extends SettlementTimeState {}

class SettlementTimeLoadingState extends SettlementTimeState {}

class SettlementTimeLoadedState extends SettlementTimeState {
  List<Priority> priorities;
  SettlementTimeLoadedState(this.priorities);
}
