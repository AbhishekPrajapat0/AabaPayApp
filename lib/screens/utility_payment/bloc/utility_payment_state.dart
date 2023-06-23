/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/models/purpose.dart';

abstract class UtilityPaymentState {}

class UtilityPaymentInitialState extends UtilityPaymentState {}

class UtilityPaymentLoadingState extends UtilityPaymentState {}

class UtilityPaymentNoBeneficiaryState extends UtilityPaymentState {
  Beneficiary beneficiary;
  List<Purpose> purposes;
  List<Priority> priorities;
  Calculation calculation;
  int purposeId;
  String amount;
  String bearer;
  int priorityId;

  UtilityPaymentNoBeneficiaryState(
      this.beneficiary,
      this.purposes,
      this.priorities,
      this.calculation,
      this.purposeId,
      this.amount,
      this.bearer,
      this.priorityId);
}

class UtilityPaymentLoadedState extends UtilityPaymentState {
  Beneficiary beneficiary;
  List<Purpose> purposes;
  List<Priority> priorities;
  Calculation calculation;
  int purposeId;
  String amount;
  String bearer;
  int priorityId;

  UtilityPaymentLoadedState(
      this.beneficiary,
      this.purposes,
      this.priorities,
      this.calculation,
      this.purposeId,
      this.amount,
      this.bearer,
      this.priorityId);
}

class UtilityPaymentErrorState extends UtilityPaymentState {
  Beneficiary beneficiary;
  List<Purpose> purposes;
  List<Priority> priorities;
  Calculation calculation;
  final String purposeErrorMessage;
  final String amountErrorMessage;
  final String bearerErrorMessage;
  final String priorityErrorMessage;
  final List<String> errorMessages;
  UtilityPaymentErrorState(
    this.beneficiary,
    this.purposes,
    this.priorities,
    this.calculation,
    this.purposeErrorMessage,
    this.amountErrorMessage,
    this.bearerErrorMessage,
    this.priorityErrorMessage,
    this.errorMessages,
  );
}

class UtilityPaymentValidState extends UtilityPaymentState {
  Payment payment;
  UtilityPaymentValidState(this.payment);
}

class UtilityPaymentOrderCreatedState extends UtilityPaymentState {}
