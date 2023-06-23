/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/ifsc.dart';

abstract class AddBeneficiaryState {}

class AddBeneficiaryInitialState extends AddBeneficiaryState {}

class AddBeneficiaryLoadedState extends AddBeneficiaryState {}

class AddBeneficiarySubmittingState extends AddBeneficiaryState {}

class AddBeneficiarySubmittedState extends AddBeneficiaryState {}

class AddBeneficiaryErrorState extends AddBeneficiaryState {
  final String accountNameErrorMessage;
  final String nickNameErrorMessage;
  final String mobileErrorMessage;
  final String accountNumberErrorMessage;
  final String confirmAccountNumberErrorMessage;
  final String ifscErrorMessage;
  final String ifscBranchErrorMessage;
  AddBeneficiaryErrorState(
      this.accountNameErrorMessage,
      this.nickNameErrorMessage,
      this.mobileErrorMessage,
      this.accountNumberErrorMessage,
      this.confirmAccountNumberErrorMessage,
      this.ifscErrorMessage,
      this.ifscBranchErrorMessage);
}

class AddIfscLoadingState extends AddBeneficiaryState {}

class AddIfscLoadedState extends AddBeneficiaryState {
  final Ifsc ifsc;
  AddIfscLoadedState(this.ifsc);
}

class AddIfscErrorState extends AddBeneficiaryState {}
