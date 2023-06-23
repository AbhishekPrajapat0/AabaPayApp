/* Tushar Ugale * Technicul.com */
abstract class BeneficiariesEvent {}

class BeneficiariesLoadEvent extends BeneficiariesEvent {}

class BeneficiariesLoadingEvent extends BeneficiariesEvent {}

class BeneficiariesLoadedEvent extends BeneficiariesEvent {}

class BeneficiariesSetPrimaryEvent extends BeneficiariesEvent {
  final int beneficiaryId;
  BeneficiariesSetPrimaryEvent(this.beneficiaryId);
}

class DeleteBeneficiaryEvent extends BeneficiariesEvent {
  final int beneficiaryId;
  DeleteBeneficiaryEvent(this.beneficiaryId);
}

class SearchBeneficiaryEvent extends BeneficiariesEvent {
  final String searchQuery;
  SearchBeneficiaryEvent(this.searchQuery);
}
