/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/models/purpose.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/add_beneficiary.dart';
import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/utility_payment/payment_options/payment_options.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/settlement_time.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/dropdowns.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_state.dart';
import 'package:aabapay_app/screens/utility_payment/bloc/utility_payment_event.dart';

class UtilityPayment extends StatefulWidget {
  Payment payment;
  bool beneficiaryAddskipped = false;
  UtilityPayment(this.payment, {required this.beneficiaryAddskipped});
  @override
  // ignore: library_private_types_in_public_api
  _UtilityPaymentState createState() => _UtilityPaymentState();
}

class _UtilityPaymentState extends State<UtilityPayment> {
  final UtilityPaymentBloc _utilityPaymentBloc = UtilityPaymentBloc();
  late FocusNode amountFocusNode;

  //Beneficiary
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

  //Purpose Dropdown
  int purposeId = 0;
  List<Purpose> purposes = [];
  String purposeErrorMessage = "";

  //Amount
  TextEditingController amountEditingController = TextEditingController();
  String amountErrorMessage = "";

  //Priority
  int priorityId = 0;
  List<Priority> priorities = [];
  String priorityErrorMessage = "";

  //Bearer
  String bearer = 'SENDER';
  String bearerErrorMessage = "";

  //Calculation
  Calculation calculation = Calculation(
      transactionAmount: 0,
      receivableAmount: 0,
      convenienceCharges: 0,
      gst: 0,
      total: 0);

  @override
  void initState() {
    double initAmount = 0.00;
    if (widget.payment.bearer == 'SENDER') {
      initAmount = widget.payment.receivableAmount;
    }
    if (widget.payment.bearer == 'RECEIVER') {
      initAmount = widget.payment.total;
    }
    if (widget.payment.bearer == 'FIFTY-FIFTY') {
      initAmount = widget.payment.total;
    }
    Calculation calculation = Calculation(
        transactionAmount: initAmount,
        receivableAmount: widget.payment.receivableAmount,
        convenienceCharges: widget.payment.convenienceCharges,
        gst: widget.payment.gst,
        total: widget.payment.total);

    _utilityPaymentBloc.add(UtilityPaymentLoadEvent(
        calculation: calculation,
        purposeId: widget.payment.purposeId,
        priorityId: widget.payment.priorityId,
        bearer: widget.payment.bearer));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Home(
                    selectedIndex: 0,
                    profileUpdatedFlag: false,
                    feedbackAddedFlag: false)),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: blackBackgroundColor,
        appBar: AppBar(
          backgroundColor: blackBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Home(
                        selectedIndex: 0,
                        profileUpdatedFlag: false,
                        feedbackAddedFlag: false)),
                (Route<dynamic> route) => false),
          ),
          title: const Text("Utility Payment Form",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 20)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettlementTime()));
                },
                icon: const Icon(Icons.info, size: 24, color: Colors.white)),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (_) => _utilityPaymentBloc,
            child: BlocListener<UtilityPaymentBloc, UtilityPaymentState>(
              listener: (context, state) {
                if (state is UtilityPaymentNoBeneficiaryState) {
                  if (widget.beneficiaryAddskipped == false) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              AddBeneficiary(fromUtilityPage: true)),
                    );
                  }
                }
                if (state is UtilityPaymentValidState) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PaymentOptions(state.payment)),
                  );
                }
                if (state is UtilityPaymentErrorState) {
                  for (String message in state.errorMessages) {
                    print(message);
                    if (message == 'beneficiary not found') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                AddBeneficiary(fromUtilityPage: true)),
                      );
                    }
                  }
                }
              },
              child: BlocBuilder<UtilityPaymentBloc, UtilityPaymentState>(
                builder: (context, state) {
                  if (state is UtilityPaymentInitialState ||
                      state is UtilityPaymentLoadingState) {
                    return _buildLoading();
                  } else {
                    if (state is UtilityPaymentLoadedState) {
                      beneficiary = state.beneficiary;
                      purposes = state.purposes;
                      priorities = state.priorities;
                      calculation = state.calculation;
                      purposeId = state.purposeId;
                      //   if (state.amount != "0.0" && state.amount != "0.00") {
                      //     amountEditingController.text =
                      //         state.amount.replaceAll('.0', '');
                      //     amountEditingController.selection =
                      //         TextSelection.fromPosition(TextPosition(
                      //             offset: amountEditingController.text.length));
                      //   }
                      bearer = state.bearer;
                      priorityId = state.priorityId;
                    }
                    if (state is UtilityPaymentNoBeneficiaryState) {
                      beneficiary = state.beneficiary;
                      purposes = state.purposes;
                      priorities = state.priorities;
                      calculation = state.calculation;
                      purposeId = state.purposeId;
                      //   if (state.amount != "0.0" && state.amount != "0.00") {
                      //     amountEditingController.text =
                      //         state.amount.replaceAll('.0', '');
                      //     amountEditingController.selection =
                      //         TextSelection.fromPosition(TextPosition(
                      //             offset: amountEditingController.text.length));
                      //   }
                      bearer = state.bearer;
                      priorityId = state.priorityId;
                    }
                    if (state is UtilityPaymentErrorState) {
                      purposeErrorMessage = state.purposeErrorMessage;
                      amountErrorMessage = state.amountErrorMessage;
                      priorityErrorMessage = state.priorityErrorMessage;
                      bearerErrorMessage = state.bearerErrorMessage;
                    }
                    return _buildHome(context, state);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(
    BuildContext context,
    UtilityPaymentState state,
  ) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  beneficiaryCard(context, state),
                  const SizedBox(height: 25),
                  purposeDropdown(),
                  const SizedBox(height: 10),
                  amountField(context),
                  const SizedBox(height: 10),
                  bearerDropdown(context),
                  const SizedBox(height: 20),
                  prioritiesButtons(context),
                  const SizedBox(height: 1),
                  priorityText(),
                  const SizedBox(height: 20),
                  calculations(context),
                  const SizedBox(height: 20),
                  errorMessages(context, state),
                  const SizedBox(height: 20),
                  payNowButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ])),
    );
  }

  Widget beneficiaryCard(
    BuildContext context,
    UtilityPaymentState state,
  ) {
    if (widget.beneficiaryAddskipped == true) {
      return SizedBox(width: 1);
    } else {
      return Container(
        height: 185,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardBackgroundColor),
        child: Column(children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: cardHeaderBackgroundColor),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Default Account",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 14),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Beneficiaries()));
                  },
                  child: Text(
                    "Change Account",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: greenTextColor,
                        fontSize: 12,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: cardBackgroundColor),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Account Holder",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: lightWhiteColor,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            beneficiary.account_holder_name,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Number",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: lightWhiteColor,
                            fontSize: 14),
                      ),
                      Text(
                        beneficiary.account_number,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "IFSC",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: lightWhiteColor,
                            fontSize: 14),
                      ),
                      Text(
                        beneficiary.ifsc_code,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile Number",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: lightWhiteColor,
                            fontSize: 14),
                      ),
                      Text(
                        beneficiary.mobile,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    }
  }

  Widget purposeDropdown() {
    List<DropdownMenuItem<int>> purposeItems = [];
    for (Purpose purpose in purposes) {
      purposeItems.add(
        DropdownMenuItem(
          value: purpose.id,
          child: Text(purpose.name),
        ),
      );

      if (purposeId == 0) {
        purposeId = purpose.id;
      }
    }

    return FloatingDropdownInt('Purpose', purposeItems, purposeId, (value) {
      purposeId = value!;
    }, purposeErrorMessage);
  }

  Widget amountField(
    BuildContext context,
  ) {
    return FloatingTextField("Amount", "", amountEditingController,
        textInputType: TextInputType.number,
        autoFocus: true,
        errorMsg: amountErrorMessage, onChange: (String? value) {
      //   Timer(Duration(seconds: 1), () {
      String amount = '0';
      if (value != '') {
        amount = value!;
      }
      BlocProvider.of<UtilityPaymentBloc>(context).add(
          UtilityPaymentCalculateEvent(beneficiary, purposes, priorities,
              calculation, amount, priorityId, purposeId, bearer));
      //   });
    });
  }

  Widget bearerDropdown(
    BuildContext context,
  ) {
    List<DropdownMenuItem<String>> bearerItems = [
      const DropdownMenuItem(
        value: 'SENDER',
        child: Text('Sender'),
      ),
      const DropdownMenuItem(
        value: 'RECEIVER',
        child: Text('Receiver'),
      ),
      const DropdownMenuItem(
        value: 'FIFTY-FIFTY',
        child: Text('50-50'),
      ),
    ];
    return FloatingDropdownString('Bearer', bearerItems, bearer, (value) {
      bearer = value!;

      BlocProvider.of<UtilityPaymentBloc>(context).add(
          UtilityPaymentCalculateEvent(
              beneficiary,
              purposes,
              priorities,
              calculation,
              amountEditingController.text,
              priorityId,
              purposeId,
              bearer));
    }, bearerErrorMessage);
  }

  Widget prioritiesButtons(
    BuildContext context,
  ) {
    List<ElevatedButton> priorityButtons = [];
    for (Priority priority in priorities) {
      // ignore: unrelated_type_equal ity_checks
      if (priorityId == 0) {
        priorityId = priority.id;
      }
      priorityButtons.add(ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              (priorityId == priority.id
                  ? greenTextColor
                  : cardHeaderBackgroundColor)),
        ),
        child: Text(
          priority.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        onPressed: () {
          setState(() {
            priorityId = priority.id;
          });
          BlocProvider.of<UtilityPaymentBloc>(context).add(
              UtilityPaymentCalculateEvent(
                  beneficiary,
                  purposes,
                  priorities,
                  calculation,
                  amountEditingController.text,
                  priority.id,
                  purposeId,
                  bearer));
        },
      ));
    }
    return Column(
      children: [
        SizedBox(
          height: (((priorityButtons.length) / 3).ceil()) * 42.00,
          child: GridView(
            physics: ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2),
            children: priorityButtons,
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(priorityErrorMessage,
                style: TextStyle(color: Colors.red, fontSize: 13)))
      ],
    );
  }

  Widget priorityText() {
    String priorityText = '';
    String prioritySmallText = '';
    for (Priority p in priorities) {
      if (p.id == priorityId) {
        priorityText = p.bigDescriptionFinal;
        prioritySmallText = p.smallDescriptionFinal;
      }
    }
    return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prioritySmallText,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: lightPrimaryColor,
              fontSize: 12),
        ),
        SizedBox(height: 10),
        Text(
          priorityText,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: lightPrimaryColor,
              fontSize: 12),
        ),
      ],
    );
  }

  Widget calculations(
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: lightBlackBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: benfCardBorderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Transaction Amount",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              Text("₹ ${calculation.transactionAmount}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: lightWhiteColor,
            height: 0,
            thickness: 1,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Receivable Amount",
                  style: TextStyle(
                      color: orangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text("₹ ${calculation.receivableAmount}",
                  style: TextStyle(
                      color: orangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Conveince Charges",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text("₹ ${calculation.convenienceCharges}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("GST",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text("₹ ${calculation.gst}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            color: lightWhiteColor,
            height: 0,
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Grand Total",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              Text("₹ ${calculation.total}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget errorMessages(BuildContext conetxt, UtilityPaymentState state) {
    if (state is UtilityPaymentErrorState) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.errorMessages.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Text(state.errorMessages[index],
                  style: const TextStyle(color: Colors.red));
            }),
      );
    } else {
      return Text('');
    }
  }

  payNowButton(
    BuildContext context,
  ) {
    return GradientButton("Pay Now:    ₹${calculation.total}", () {
      BlocProvider.of<UtilityPaymentBloc>(context).add(
          UtilityPaymentDoPaymentEvent(
              beneficiary,
              purposes,
              priorities,
              calculation,
              amountEditingController.text,
              priorityId,
              bearer,
              purposeId));
    });
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
