/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_state.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/bloc/edit_beneficiary_event.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:aabapay_app/widgets/buttons.dart';

class EditBeneficiary extends StatefulWidget {
  Beneficiary beneficiary;
  EditBeneficiary(this.beneficiary);

  @override
  _EditBeneficiaryState createState() => _EditBeneficiaryState();
}

class _EditBeneficiaryState extends State<EditBeneficiary> {
  final EditBeneficiaryBloc _EditBeneficiaryBloc = EditBeneficiaryBloc();

  TextEditingController accountNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccountNumberController =
      TextEditingController();
  TextEditingController ifscController = TextEditingController();

  @override
  void initState() {
    _EditBeneficiaryBloc.add(EditBeneficiaryLoadEvent(widget.beneficiary));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Add Beneficiary",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _EditBeneficiaryBloc,
          child: BlocListener<EditBeneficiaryBloc, EditBeneficiaryState>(
            listener: (context, state) {
              if (state is EditBeneficiarySubmittedState) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Home(
                          selectedIndex: 1,
                          profileUpdatedFlag: false,
                          feedbackAddedFlag: false)),
                );
              }
            },
            child: BlocBuilder<EditBeneficiaryBloc, EditBeneficiaryState>(
              builder: (context, state) {
                Map<String, String> validationErrors = {
                  "accountNameErrorMessage": '',
                  "nickNameErrorMessage": '',
                  "mobileErrorMessage": '',
                  "accountNumberErrorMessage": '',
                  "confirmAccountNumberErrorMessage": '',
                  "ifscErrorMessage": '',
                };
                if (state is EditBeneficiaryErrorState) {
                  validationErrors['accountNameErrorMessage'] =
                      state.accountNameErrorMessage;
                  validationErrors['nickNameErrorMessage'] =
                      state.nickNameErrorMessage;
                  validationErrors['mobileErrorMessage'] =
                      state.mobileErrorMessage;
                  validationErrors['accountNumberErrorMessage'] =
                      state.accountNumberErrorMessage;
                  validationErrors['confirmAccountNumberErrorMessage'] =
                      state.confirmAccountNumberErrorMessage;
                  validationErrors['ifscErrorMessage'] = state.ifscErrorMessage;
                }
                if (state is EditBeneficiaryInitialState) {
                  return _buildLoading();
                } else {
                  return _buildHome(context, state, validationErrors);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(
      BuildContext context, EditBeneficiaryState state, Map validationErrors) {
    if (state is EditBeneficiaryLoadedState) {
      accountNameController.text = state.beneficiary.account_holder_name;
      nickNameController.text = state.beneficiary.nickname;
      mobileController.text = state.beneficiary.mobile;
      accountNumberController.text = state.beneficiary.account_number;
      confirmAccountNumberController.text = state.beneficiary.account_number;
      ifscController.text = state.beneficiary.ifsc_code;
    }
    return SafeArea(
        bottom: true,
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: [
              FloatingTextField("Account Holder Name", "XXXX XXXX XXXX",
                  accountNameController,
                  capital: AppConstants.CAPTIAL_WORDS,
                  autoFocus: true,
                  errorMsg: validationErrors['accountNameErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 10),
              FloatingTextField("Nickname", "XXXXX", nickNameController,
                  capital: AppConstants.CAPTIAL_WORDS,
                  errorMsg: validationErrors['nickNameErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 10),
              FloatingTextField("Beneficiary Mobile Number", "XXXXX-XXXX-XXX",
                  mobileController,
                  textInputType: TextInputType.phone,
                  errorMsg: validationErrors['mobileErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 10),
              FloatingTextField(
                  "Account Number", "XXXXXXXXXXXXXXXX", accountNumberController,
                  textInputType: TextInputType.number,
                  errorMsg: validationErrors['accountNumberErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 10),
              FloatingTextField("Confirm Account Number", "XXXXXXXXXXXXXXXX",
                  confirmAccountNumberController,
                  textInputType: TextInputType.number,
                  errorMsg:
                      validationErrors['confirmAccountNumberErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 10),
              FloatingTextField("IFSC", "XXXXXXXXXXX", ifscController,
                  capital: AppConstants.CAPTIAL_ALL,
                  errorMsg: validationErrors['ifscErrorMessage'],
                  onChange: (String? value) {}),
              const SizedBox(height: 40),
              GradientButton("Update", () {
                BlocProvider.of<EditBeneficiaryBloc>(context).add(
                    EditBeneficiarySubmittedEvent(
                        widget.beneficiary.id,
                        accountNameController.text,
                        nickNameController.text,
                        mobileController.text,
                        accountNumberController.text,
                        confirmAccountNumberController.text,
                        ifscController.text));
              },
                  isLoading:
                      (state is EditBeneficiarySubmittingState) ? true : false),
            ]),
          ),
        ));
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
