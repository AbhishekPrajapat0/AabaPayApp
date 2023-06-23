/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';

abstract class EditBeneficiaryEvent {}

class EditBeneficiaryLoadEvent extends EditBeneficiaryEvent {
  Beneficiary beneficiary;
  EditBeneficiaryLoadEvent(this.beneficiary);
}

class EditBeneficiarySubmittedEvent extends EditBeneficiaryEvent {
  final int id;
  final String accountName;
  final String nickName;
  final String mobile;
  final String accountNumber;
  final String confirmAccountNumber;
  final String ifsc;
  EditBeneficiarySubmittedEvent(this.id, this.accountName, this.nickName,
      this.mobile, this.accountNumber, this.confirmAccountNumber, this.ifsc);
}
