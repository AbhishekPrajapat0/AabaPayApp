/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/purpose.dart';
import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_event.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_state.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/models/priority.dart';

class UtilityPaymentBloc
    extends Bloc<UtilityPaymentEvent, UtilityPaymentState> {
  final UtilityPaymentApi utilityPaymentApi = UtilityPaymentApi();
  String selectedBearerItem = 'SENDER';
  UtilityPaymentBloc() : super(UtilityPaymentInitialState()) {
    on<UtilityPaymentLoadEvent>((event, emit) async {
      emit(UtilityPaymentLoadingState());
      await utilityPaymentApi.paymentCreate().then((value) {
        List<Purpose> purposes = List<Purpose>.from(
            value['purposes'].map((model) => Purpose.fromJson(model))).toList();

        List<Priority> priorities = List<Priority>.from(
                value['priorities'].map((model) => Priority.fromJson(model)))
            .toList();
        // print("----->  ${priorities[0].name}");

        Beneficiary beneficiary = Beneficiary(
          id: 0,
          user_id: 0,
          account_holder_name: "",
          nickname: "",
          mobile: "",
          account_number: "",
          ifsc_code: "",
          primary: 0,
          status: "",
          verificationStatus: "",
        );
        if (value['default_beneficiary'].length == 0) {
          emit(UtilityPaymentNoBeneficiaryState(
            beneficiary,
            purposes,
            priorities,
            event.calculation,
            event.purposeId,
            event.calculation.transactionAmount.toString(),
            event.bearer,
            event.priorityId,
          ));
        } else {
          beneficiary = Beneficiary.fromJson(value['default_beneficiary']);
        }
        emit(UtilityPaymentLoadedState(
          beneficiary,
          purposes,
          priorities,
          event.calculation,
          event.purposeId,
          event.calculation.transactionAmount.toString(),
          event.bearer,
          event.priorityId,
        ));
      });
    });

    on<UtilityPaymentCalculateEvent>((event, emit) async {
      String amount = '0';
      if (event.amount != '') {
        amount = event.amount;
      }
      await utilityPaymentApi
          .paymentCalculation(event.amount, event.bearer, event.priorityId)
          .then((value) {
        //   print(2222);
        //   print(event.purposeId);
        Calculation calculation = Calculation.fromJson(value);
        emit(UtilityPaymentLoadedState(
          event.beneficiary,
          event.purposes,
          event.priorities,
          calculation,
          event.purposeId,
          event.amount,
          event.bearer,
          event.priorityId,
        ));
      });
    });

    on<UtilityPaymentDoPaymentEvent>((event, emit) async {
      //   print(333);
      //   print(event.purposeId);
      await utilityPaymentApi
          .paymentCalculationValidation(
              event.beneficiary.id,
              event.calculation.receivableAmount,
              event.calculation.convenienceCharges,
              event.calculation.gst,
              event.calculation.total,
              event.amount,
              event.purposeId,
              event.bearer,
              event.priorityId)
          .then((value) {
        String purposeErrorMessage = '';
        String amountErrorMessage = '';
        String bearerErrorMessage = '';
        String priorityErrorMessage = '';
        List<String> errorMessages = [];

        if (value['errors'] != null) {
          value['errors'].forEach((k, v) {
            String error;
            if (v.runtimeType == String) {
              error = v.toString();
            } else {
              error = v[0].toString();
            }
            if (k == 'purpose_id') {
              purposeErrorMessage = error;
            } else if (k == 'receivable_amount' ||
                k == 'convenience_charges' ||
                k == 'gst' ||
                k == 'total_amount' ||
                k == 'amount') {
              amountErrorMessage = error;
            } else if (k == 'bearer') {
              bearerErrorMessage = error;
            } else if (k == 'priority_id') {
              priorityErrorMessage = error;
            } else {
              errorMessages.add(error);
            }
          });
        }
        if (value['error_messages'] != '' && value['error_messages'] != null) {
          errorMessages.add(value['error_messages']);
        }
        if (purposeErrorMessage != '' ||
            amountErrorMessage != '' ||
            bearerErrorMessage != '' ||
            priorityErrorMessage != '' ||
            errorMessages.isNotEmpty) {
          emit(UtilityPaymentErrorState(
              event.beneficiary,
              event.purposes,
              event.priorities,
              event.calculation,
              purposeErrorMessage,
              amountErrorMessage,
              bearerErrorMessage,
              priorityErrorMessage,
              errorMessages));
        } else {
          if (value['message'] == 'Payment Valid') {
            Payment payment = Payment(
              beneficiaryId: event.beneficiary.id,
              transactionAmount: event.calculation.transactionAmount,
              receivableAmount: event.calculation.receivableAmount,
              convenienceCharges: event.calculation.convenienceCharges,
              gst: event.calculation.gst,
              total: event.calculation.total,
              purposeId: event.purposeId,
              bearer: event.bearer,
              priorityId: event.priorityId,
              paymentOptionId: 0,
              paymentOptionDesc: '',
            );
            emit(UtilityPaymentValidState(payment));
          } else {}
        }
      });
    });
  }
}
