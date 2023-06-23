/* Tushar Ugale * Technicul.com */
// ignore_for_file: sort_child_properties_last

import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/screens/beneficiaries/add_beneficiary/add_beneficiary.dart';
import 'package:aabapay_app/screens/beneficiaries/edit_beneficiary/edit_beneficiary.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/utility_payment/utility_payment.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_bloc.dart';
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_state.dart';
import 'package:aabapay_app/screens/beneficiaries/bloc/beneficiaries_event.dart';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Beneficiaries extends StatefulWidget {
  @override
  _BeneficiariesState createState() => _BeneficiariesState();
}

class _BeneficiariesState extends State<Beneficiaries> {
  final BeneficiariesBloc _beneficiariesBloc = BeneficiariesBloc();

  @override
  void initState() {
    _beneficiariesBloc.add(BeneficiariesLoadEvent());
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
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 0,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)),
              (Route<dynamic> route) => false),
        ),
        title: const Text("Beneficiaries",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _beneficiariesBloc,
          child: BlocListener<BeneficiariesBloc, BeneficiariesState>(
            listener: (context, state) {},
            child: BlocBuilder<BeneficiariesBloc, BeneficiariesState>(
              builder: (context, state) {
                if (state is BeneficiariesInitialState ||
                    state is BeneficiariesLoadingState) {
                  return _buildLoading();
                } else {
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, BeneficiariesState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            const SizedBox(height: 10),
            search(context, state),
            const SizedBox(height: 10),
            beneficiaryList(context, state),
          ])),
    );
  }

  Widget search(BuildContext context, BeneficiariesState state) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  fillColor: cardHeaderBackgroundColor,
                  focusColor: cardHeaderBackgroundColor,
                  hoverColor: cardHeaderBackgroundColor,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  hintStyle: TextStyle(
                    color: searchBarHintColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, color: searchBarHintColor)),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
              onChanged: (searchQuery) {
                BlocProvider.of<BeneficiariesBloc>(context)
                    .add(SearchBeneficiaryEvent(searchQuery));
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddBeneficiary(
                        fromUtilityPage: false,
                      )));
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: darkPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_box, color: Colors.white, size: 24),
            ),
          )
        ],
      ),
    );
  }

  Widget beneficiaryList(BuildContext context, BeneficiariesState state) {
    List<Beneficiary> beneficiaries = [];

    if (state is BeneficiariesLoadedState) {
      for (Beneficiary beneficiary in state.beneficiaries) {
        if (beneficiary.primary == 0) {
          beneficiaries.add(beneficiary);
        }
      }
      for (Beneficiary beneficiary in state.beneficiaries) {
        if (beneficiary.primary == 1) {
          beneficiaries.add(beneficiary);
        }
      }

      return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: beneficiaries.length,
            padding: EdgeInsets.symmetric(vertical: 5),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (beneficiaries[index].primary == 0) {
                return primaryBeneficiary(beneficiaries[index], context);
              } else {
                return normalBeneficiary(beneficiaries[index], context);
              }
            }),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget primaryBeneficiary(Beneficiary beneficiary, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: primaryAccBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cardBorderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(beneficiary.account_holder_name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: lightPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text("Primary",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                  PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          //   case 'Edit':
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) =>
                          //             EditBeneficiary(beneficiary)));
                          //     break;
                          case 'Delete':
                            Widget cancelButton = TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: whiteColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = ElevatedButton(
                              onPressed: () {
                                print('yes selected');
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(color: whiteColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: darkRedColor),
                            );
                            // Widget continueButton = TextButton(
                            //   child: Text("Yes, Delete It", style: TextStyle(color: whiteColor),),
                            //   onPressed: () {
                            //     BlocProvider.of<BeneficiariesBloc>(context).add(
                            //         DeleteBeneficiaryEvent(beneficiary.id));
                            //     Navigator.of(context).pop();
                            //   },
                            // );

                            AlertDialog alert = AlertDialog(
                              backgroundColor: cardHeaderBackgroundColor,
                              title: Text(
                                "Are You Sure?",
                                style: TextStyle(color: whiteColor),
                              ),
                              content: Text(
                                "Do you really want to delete this beneficiary?",
                                style: TextStyle(color: whiteColor),
                              ),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                            break;
                        }
                      },
                      color: Colors.white,
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext itemBuilder) => [
                            // const PopupMenuItem(
                            //   child: Align(
                            //       child: Text('Edit'),
                            //       alignment: Alignment.topRight),
                            //   value: 'Edit',
                            //   height: 30,
                            //   textStyle: TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w400,
                            //       color: Colors.black),
                            // ),
                            const PopupMenuItem(
                              child: Align(
                                  child: Text('Delete'),
                                  alignment: Alignment.topRight),
                              value: 'Delete',
                              height: 30,
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            ),
                          ])
                ],
              )
            ],
          ),
          Text("Account #: ${beneficiary.account_number}",
              style: TextStyle(
                  color: lightWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text("IFSC: ${beneficiary.ifsc_code}",
                    style: TextStyle(
                        color: lightWhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                child: Text("Mobile: ${beneficiary.mobile}",
                    style: TextStyle(
                        color: lightWhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            color: dividerColor,
            thickness: 0.3,
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget normalBeneficiary(Beneficiary beneficiary, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      margin: EdgeInsets.symmetric(vertical: 7),
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
              Expanded(
                child: Text(beneficiary.account_holder_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
              ),
              PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      //   case 'Edit':
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) =>
                      //             EditBeneficiary(beneficiary)));
                      //     break;
                      case 'Delete':
                        Widget cancelButton = TextButton(
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            // Background Color
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                        Widget continueButton = TextButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.red, // Background Color
                          ),
                          onPressed: () {
                            BlocProvider.of<BeneficiariesBloc>(context)
                                .add(DeleteBeneficiaryEvent(beneficiary.id));
                            Navigator.of(context).pop();
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: const Text("Are You Sure?"),
                          content: const Text(
                              "Do you really want to delete this beneficiary?"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                        break;
                      case 'Set As Primary A/C':
                        _beneficiariesBloc
                            .add(BeneficiariesSetPrimaryEvent(beneficiary.id));
                        Fluttertoast.showToast(
                            msg: "Primary Set Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0);
                        break;
                    }
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext itemBuilder) => [
                        const PopupMenuItem(
                          child: Align(
                              child: Text('Set As Primary A/C'),
                              alignment: Alignment.topRight),
                          value: 'Set As Primary A/C',
                          height: 30,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        // const PopupMenuItem(
                        //   child: Align(
                        //       child: Text('Edit'),
                        //       alignment: Alignment.topRight),
                        //   value: 'Edit',
                        //   height: 30,
                        //   textStyle: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w400,
                        //       color: Colors.black),
                        // ),
                        const PopupMenuItem(
                          child: Align(
                              child: Text('Delete'),
                              alignment: Alignment.topRight),
                          value: 'Delete',
                          height: 30,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        )
                      ])
            ],
          ),
          Text("Account #: ${beneficiary.account_number}",
              style: TextStyle(
                  color: lightWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text("IFSC: ${beneficiary.ifsc_code}",
                    style: TextStyle(
                        color: lightWhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                child: Text("Mobile: ${beneficiary.mobile}",
                    style: TextStyle(
                        color: lightWhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
