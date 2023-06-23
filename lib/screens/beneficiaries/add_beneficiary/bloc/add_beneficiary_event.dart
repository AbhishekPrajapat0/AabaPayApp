/* Tushar Ugale * Technicul.com */
abstract class AddBeneficiaryEvent {}

class AddBeneficiaryLoadEvent extends AddBeneficiaryEvent {}

class AddBeneficiarySubmittedEvent extends AddBeneficiaryEvent {
  final String accountName;
  final String nickName;
  final String mobile;
  final String accountNumber;
  final String confirmAccountNumber;
  final String ifsc;
  final String ifscBranch;
  AddBeneficiarySubmittedEvent(
      this.accountName,
      this.nickName,
      this.mobile,
      this.accountNumber,
      this.confirmAccountNumber,
      this.ifsc,
      this.ifscBranch);
}

class CheckIfscEvent extends AddBeneficiaryEvent {
  final String ifsc;
  CheckIfscEvent(this.ifsc);
}
