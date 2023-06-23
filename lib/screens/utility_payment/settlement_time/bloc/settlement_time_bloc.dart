/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_event.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_state.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettlementTimeBloc
    extends Bloc<SettlementTimeEvent, SettlementTimeState> {
  final SettlementTimeApi settlementTimeApi = SettlementTimeApi();

  SettlementTimeBloc() : super(SettlementTimeInitialState()) {
    on<SettlementTimeLoadEvent>((event, emit) async {
      await settlementTimeApi.settlementTime().then((value) {
        List<Priority> priorities =
            List<Priority>.from(value.map((model) => Priority.fromJson(model)))
                .toList();
        emit(SettlementTimeLoadedState(priorities));
      });
    });
  }
}
