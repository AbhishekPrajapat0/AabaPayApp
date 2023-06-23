/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';

abstract class EditBeneficiaryState {}

class EditBeneficiaryInitialState extends EditBeneficiaryState {}

class EditBeneficiaryLoadedState extends EditBeneficiaryState {
  Beneficiary beneficiary;
  EditBeneficiaryLoadedState(this.beneficiary);
}

class EditBeneficiarySubmittingState extends EditBeneficiaryState {}

class EditBeneficiarySubmittedState extends EditBeneficiaryState {}

class EditBeneficiaryErrorState extends EditBeneficiaryState {
  final String accountNameErrorMessage;
  final String nickNameErrorMessage;
  final String mobileErrorMessage;
  final String accountNumberErrorMessage;
  final String confirmAccountNumberErrorMessage;
  final String ifscErrorMessage;
  EditBeneficiaryErrorState(
      this.accountNameErrorMessage,
      this.nickNameErrorMessage,
      this.mobileErrorMessage,
      this.accountNumberErrorMessage,
      this.confirmAccountNumberErrorMessage,
      this.ifscErrorMessage);
}
