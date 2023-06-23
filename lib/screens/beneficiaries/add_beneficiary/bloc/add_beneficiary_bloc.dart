/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/ifsc.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_event.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_state.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBeneficiaryBloc
    extends Bloc<AddBeneficiaryEvent, AddBeneficiaryState> {
  final AddBeneficiaryApi addBeneficiaryApi = AddBeneficiaryApi();

  AddBeneficiaryBloc() : super(AddBeneficiaryInitialState()) {
    /* Load Event * Tushar Ugale * Technicul.com */
    on<AddBeneficiaryLoadEvent>((event, emit) async {
      emit(AddBeneficiaryLoadedState());
    });

    on<CheckIfscEvent>((event, emit) async {
      emit(AddIfscLoadingState());
      if (event.ifsc != '') {
        await addBeneficiaryApi.checkIFSC(event.ifsc).then((value) {
          if (value != 'Not Found') {
            Ifsc ifsc = Ifsc.fromJson(value);
            emit(AddIfscLoadedState(ifsc));
          } else {
            emit(AddIfscErrorState());
          }
        });
      }
    });

    /* Form Submission Event * Tushar Ugale * Technicul.com */
    on<AddBeneficiarySubmittedEvent>((event, emit) async {
      emit(AddBeneficiarySubmittingState());

      await addBeneficiaryApi
          .addBeneficiary(
              event.accountName,
              event.nickName,
              event.mobile,
              event.accountNumber,
              event.confirmAccountNumber,
              event.ifsc,
              event.ifscBranch)
          .then((value) {
        String accountName = '';
        String nickName = '';
        String mobile = '';
        String accountNumber = '';
        String confirmAccountNumber = '';
        String ifsc = '';
        String ifscBranch = '';
        if (value['errors'] != null) {
          value['errors'].forEach((k, v) {
            var error;
            if (v.runtimeType == String) {
              error = v.toString();
            } else {
              error = v[0].toString();
            }

            if (k == 'account_holder_name') {
              accountName = error;
            }
            if (k == 'nickname') {
              nickName = error;
            }
            if (k == 'mobile') {
              mobile = error;
            }
            if (k == 'account_number') {
              accountNumber = error;
            }
            if (k == 'confirm_account_number') {
              confirmAccountNumber = error;
            }
            if (k == 'ifsc_code') {
              ifsc = error;
            }
            if (k == 'ifsc_branch') {
              ifscBranch = error;
            }
          });
        }

        /* If any validation error * Tushar Ugale * Technicul.com */
        if (accountName != '' ||
            nickName != '' ||
            mobile != '' ||
            accountNumber != '' ||
            confirmAccountNumber != '' ||
            ifsc != '' ||
            ifscBranch != '') {
          emit(AddBeneficiaryErrorState(accountName, nickName, mobile,
              accountNumber, confirmAccountNumber, ifsc, ifscBranch));
        }

        /* if api response successul * Tushar Ugale * Technicul.com */
        if (value['message'].toString().toLowerCase() ==
            'Beneficiary added successfully'.toLowerCase()) {
          emit(AddBeneficiarySubmittedState());
        }
      });
    });
  }
}
