/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/kyc.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_event.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_state.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final KycApi kycApi = KycApi();

  KycBloc() : super(KycInitialState()) {
    on<KycLoadEvent>((event, emit) async {
      await kycApi.getKycStatus().then((value) {
        List<Kyc> kycs =
            List<Kyc>.from(value['data'].map((model) => Kyc.fromJson(model)))
                .toList();
        emit(KycLoadedState(kycs));
      });
    });
  }
}
