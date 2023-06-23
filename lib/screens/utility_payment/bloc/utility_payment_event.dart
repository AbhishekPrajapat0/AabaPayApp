/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/models/purpose.dart';

abstract class UtilityPaymentEvent {}

class UtilityPaymentLoadEvent extends UtilityPaymentEvent {
  Calculation calculation;
  int purposeId;
  int priorityId;
  String bearer;
  UtilityPaymentLoadEvent(
      {required this.calculation,
      required this.purposeId,
      required this.priorityId,
      required this.bearer});
}

class UtilityPaymentCalculateEvent extends UtilityPaymentEvent {
  Beneficiary beneficiary;
  List<Purpose> purposes;

  List<Priority> priorities;
  Calculation calculation;
  String amount;
  int priorityId;
  int purposeId;
  String bearer;
  UtilityPaymentCalculateEvent(
      this.beneficiary,
      this.purposes,
      this.priorities,
      this.calculation,
      this.amount,
      this.priorityId,
      this.purposeId,
      this.bearer);
}

class UtilityPaymentDoPaymentEvent extends UtilityPaymentEvent {
  Beneficiary beneficiary;
  List<Purpose> purposes;
  List<Priority> priorities;
  Calculation calculation;
  String amount;
  int priorityId;
  String bearer;
  int purposeId;
  UtilityPaymentDoPaymentEvent(
      this.beneficiary,
      this.purposes,
      this.priorities,
      this.calculation,
      this.amount,
      this.priorityId,
      this.bearer,
      this.purposeId);
}
