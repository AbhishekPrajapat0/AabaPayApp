/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_event.dart';
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_state.dart';
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/models/beneficiary.dart';

class BeneficiariesBloc extends Bloc<BeneficiariesEvent, BeneficiariesState> {
  final BeneficiariesApi beneficiariesApi = BeneficiariesApi();

  BeneficiariesBloc() : super(BeneficiariesInitialState()) {
    on<BeneficiariesLoadEvent>((event, emit) async {
      emit(BeneficiariesLoadingState());
      await beneficiariesApi.beneficiaries().then((value) {
        List<Beneficiary> beneficiaries = List<Beneficiary>.from(
            value['data'].map((model) => Beneficiary.fromJson(model))).toList();
        emit(BeneficiariesLoadedState(beneficiaries));
      });
    });

    on<BeneficiariesSetPrimaryEvent>((event, emit) async {
      emit(BeneficiariesLoadingState());
      await beneficiariesApi
          .setBeneficiaryAsPrimary(event.beneficiaryId)
          .then((value) {
        if (value["message"].toString().toLowerCase() ==
            "Default beneficiary set successfully".toLowerCase()) {
          this.add(BeneficiariesLoadEvent());
        }
      });
    });

    on<DeleteBeneficiaryEvent>((event, emit) async {
      emit(BeneficiariesLoadingState());
      await beneficiariesApi
          .deleteBeneficiary(event.beneficiaryId)
          .then((value) {
        if (value["message"].toString().toLowerCase() ==
            "Beneficiary deleted successfully".toLowerCase()) {
          this.add(BeneficiariesLoadEvent());
        }
      });
    });

    on<SearchBeneficiaryEvent>((event, emit) async {
      await beneficiariesApi
          .searchBeneficiaries(event.searchQuery)
          .then((value) {
        List<Beneficiary> beneficiaries = List<Beneficiary>.from(
            value['data'].map((model) => Beneficiary.fromJson(model))).toList();
        emit(BeneficiariesLoadedState(beneficiaries));
      });
    });
  }
}
