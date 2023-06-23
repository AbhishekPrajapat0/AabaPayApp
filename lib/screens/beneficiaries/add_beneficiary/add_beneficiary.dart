/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:aabapay_app/models/ifsc.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/utility_payment/utility_payment.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_state.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/bloc/add_beneficiary_event.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:aabapay_app/widgets/buttons.dart';

class AddBeneficiary extends StatefulWidget {
  bool fromUtilityPage = false;
  AddBeneficiary({required this.fromUtilityPage});
  @override
  _AddBeneficiaryState createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
  final AddBeneficiaryBloc _addBeneficiaryBloc = AddBeneficiaryBloc();

  TextEditingController accountNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccountNumberController =
      TextEditingController();
  TextEditingController ifscController = TextEditingController();
  Ifsc ifscCode =
      Ifsc(BRANCH: '', ADDRESS: '', MICR: '', CITY: '', DISTRICT: '');

  @override
  void initState() {
    _addBeneficiaryBloc.add(AddBeneficiaryLoadEvent());
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
        title: Text("Add Beneficiary",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
        actions: [
          (widget.fromUtilityPage == true
              ? GestureDetector(
                  onTap: () {
                    Payment payment = Payment(
                      beneficiaryId: 0,
                      transactionAmount: 0,
                      receivableAmount: 0,
                      convenienceCharges: 0,
                      gst: 0,
                      total: 0,
                      purposeId: 0,
                      bearer: 'SENDER',
                      priorityId: 0,
                      paymentOptionId: 0,
                      paymentOptionDesc: '',
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UtilityPayment(payment,
                            beneficiaryAddskipped: true)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'skip >',
                      style: TextStyle(
                        fontSize: 20,
                        color: lightPrimaryColor,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ))
              : Text(''))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _addBeneficiaryBloc,
          child: BlocListener<AddBeneficiaryBloc, AddBeneficiaryState>(
            listener: (context, state) {
              if (state is AddBeneficiarySubmittedState) {
                print(1);
                confirmBox(context);
              }
            },
            child: BlocBuilder<AddBeneficiaryBloc, AddBeneficiaryState>(
              builder: (context, state) {
                Map<String, String> validationErrors = {
                  "accountNameErrorMessage": '',
                  "nickNameErrorMessage": '',
                  "mobileErrorMessage": '',
                  "accountNumberErrorMessage": '',
                  "confirmAccountNumberErrorMessage": '',
                  "ifscErrorMessage": '',
                  "ifscBranchErrorMessage": '',
                };
                if (state is AddBeneficiaryErrorState) {
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
                  validationErrors['ifscBranchErrorMessage'] =
                      state.ifscBranchErrorMessage;
                }
                if (state is AddBeneficiaryInitialState) {
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
      BuildContext context, AddBeneficiaryState state, Map validationErrors) {
    return SafeArea(
        bottom: true,
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: [
              FloatingTextField(
                "Account Holder Name",
                "XXXX XXXX XXXX",
                accountNameController,
                autoFocus: true,
                capital: AppConstants.CAPTIAL_WORDS,
                errorMsg: validationErrors['accountNameErrorMessage'],
                onChange: (String? value) {},
              ),
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
              ifsc(context, state, validationErrors),
              const SizedBox(height: 40),
              GradientButton("Save", () {
                BlocProvider.of<AddBeneficiaryBloc>(context).add(
                    AddBeneficiarySubmittedEvent(
                        accountNameController.text,
                        nickNameController.text,
                        mobileController.text,
                        accountNumberController.text,
                        confirmAccountNumberController.text,
                        ifscController.text,
                        ifscCode.BRANCH));
              },
                  isLoading:
                      (state is AddBeneficiarySubmittingState) ? true : false),
            ]),
          ),
        ));
  }

  Widget ifsc(
      BuildContext context, AddBeneficiaryState state, Map validationErrors) {
    String errorMessage = '';
    String ifscBranch = '';
    String ifscAddress = '';
    if (state is AddIfscLoadedState) {
      ifscCode = state.ifsc;
      ifscBranch =
          "${state.ifsc.BRANCH}, ${state.ifsc.CITY}, ${state.ifsc.DISTRICT}";
      ifscAddress = state.ifsc.ADDRESS;
    }
    if (state is AddIfscErrorState) {
      ifscCode =
          Ifsc(BRANCH: '', ADDRESS: '', MICR: '', CITY: '', DISTRICT: '');
      errorMessage = 'Not Found';
    } else {
      errorMessage = validationErrors['ifscErrorMessage'];
      if (validationErrors['ifscBranchErrorMessage'] != '') {
        errorMessage = validationErrors['ifscBranchErrorMessage'];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FloatingTextField("IFSC", "XXXXXXXXXXX", ifscController,
            capital: AppConstants.CAPTIAL_ALL,
            errorMsg: errorMessage, onChange: (String? value) {
          BlocProvider.of<AddBeneficiaryBloc>(context)
              .add(CheckIfscEvent(ifscController.text));
        }),
        Row(
          children: [
            (ifscBranch != ''
                ? Icon(
                    Icons.location_on,
                    color: Colors.red,
                  )
                : Text('')),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                ifscBranch,
                style: TextStyle(color: lightPrimaryColor, fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            SizedBox(width: 27),
            Expanded(
              child: Text(
                ifscAddress,
                style: TextStyle(color: lightPrimaryColor, fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget confirmBox(BuildContext ctx) {
    var pageHeight = MediaQuery.of(ctx).size.height;
    var pageWidth = MediaQuery.of(ctx).size.width;

    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Home(
                    selectedIndex: 1,
                    profileUpdatedFlag: false,
                    feedbackAddedFlag: false)),
            (Route<dynamic> route) => false);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(lightPrimaryColor),
        overlayColor: MaterialStateProperty.all(lightPrimaryColor),
        backgroundColor: MaterialStateProperty.all(lightPrimaryColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pageWidth / 25, right: pageWidth / 25),
        child: Text(
          'Ok. Got It.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: cardBackgroundColor,
      title: Center(
          child: Column(
        children: [
          Text("Beneficiary Added", style: TextStyle(color: lightPrimaryColor)),
          const SizedBox(height: 10),
        ],
      )),
      // content: Text(""),

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          List<DropdownMenuItem<int>> priorityItems = [];

          return Container(
              height: height - (height * 85 / 100),
              width: width,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: lightPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Beneficiary Added',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: lightPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Beneficiary Verified',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: lightPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Start doing utility payment to this beneficiary now',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ));
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              continueButton,
            ],
          ),
        )
      ],
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
    return const Text('');
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
