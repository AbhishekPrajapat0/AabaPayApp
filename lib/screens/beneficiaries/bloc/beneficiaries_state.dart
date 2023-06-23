/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';

abstract class BeneficiariesState {}

class BeneficiariesInitialState extends BeneficiariesState {}

class BeneficiariesLoadedState extends BeneficiariesState {
  final List<Beneficiary> beneficiaries;
  BeneficiariesLoadedState(this.beneficiaries);
}

class BeneficiariesLoadingState extends BeneficiariesState {}
