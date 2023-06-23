/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_event.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_state.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBeneficiaryBloc
    extends Bloc<EditBeneficiaryEvent, EditBeneficiaryState> {
  final EditBeneficiaryApi editBeneficiaryApi = EditBeneficiaryApi();

  EditBeneficiaryBloc() : super(EditBeneficiaryInitialState()) {
    on<EditBeneficiaryLoadEvent>((event, emit) async {
      emit(EditBeneficiaryLoadedState(event.beneficiary));
    });

    on<EditBeneficiarySubmittedEvent>((event, emit) async {
      emit(EditBeneficiarySubmittingState());

      await editBeneficiaryApi
          .editBeneficiary(
              event.id,
              event.accountName,
              event.nickName,
              event.mobile,
              event.accountNumber,
              event.confirmAccountNumber,
              event.ifsc)
          .then((value) {
        String accountName = '';
        String nickName = '';
        String mobile = '';
        String accountNumber = '';
        String confirmAccountNumber = '';
        String ifsc = '';
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
          });
        }

        if (accountName != '' ||
            nickName != '' ||
            mobile != '' ||
            accountNumber != '' ||
            confirmAccountNumber != '' ||
            ifsc != '') {
          emit(EditBeneficiaryErrorState(accountName, nickName, mobile,
              accountNumber, confirmAccountNumber, ifsc));
        }

        if (value['message'].toString().toLowerCase() ==
            'Beneficiary updated successfully'.toLowerCase()) {
          emit(EditBeneficiarySubmittedState());
        }
      });
    });
  }
}
