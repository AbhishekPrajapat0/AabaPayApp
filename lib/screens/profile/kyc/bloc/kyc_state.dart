/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/kyc.dart';

abstract class KycState {}

class KycInitialState extends KycState {}

class KycLoadingState extends KycState {}

class KycLoadedState extends KycState {
  List<Kyc> kycs = [];
  KycLoadedState(this.kycs);
}
