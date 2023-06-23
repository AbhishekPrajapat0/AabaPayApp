/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_bloc.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_state.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/bloc/settlement_time_event.dart';

class SettlementTime extends StatefulWidget {
  @override
  _SettlementTimeState createState() => _SettlementTimeState();
}

class _SettlementTimeState extends State<SettlementTime> {
  final SettlementTimeBloc _settlementTimeBloc = SettlementTimeBloc();

  @override
  void initState() {
    _settlementTimeBloc.add(SettlementTimeLoadEvent());
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
        title: const Text("Settlement Time",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _settlementTimeBloc,
          child: BlocListener<SettlementTimeBloc, SettlementTimeState>(
            listener: (context, state) {},
            child: BlocBuilder<SettlementTimeBloc, SettlementTimeState>(
              builder: (context, state) {
                if (state is SettlementTimeInitialState ||
                    state is SettlementTimeLoadingState) {
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

  Widget _buildHome(BuildContext context, SettlementTimeState state) {
    if (state is SettlementTimeLoadedState) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.priorities.length,
                itemBuilder: (context, index) {
                  if (index != (state.priorities.length) - 1) {
                    return Container(
                      height: 130.0,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cardBackgroundColor),
                      child: Column(
                        children: [
                          Container(
                            // height: 40,
                            width: double.infinity,

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: cardHeaderBackgroundColor),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    "${state.priorities[index].name} *",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    state.priorities[index].charge.toString() +
                                        '%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.yellow,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: cardBackgroundColor),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Text(
                                "${state.priorities[index].settlementDescription}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 130.0,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: cardBackgroundColor),
                          child: Column(
                            children: [
                              Container(
                                // height: 40,
                                width: double.infinity,

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    color: cardHeaderBackgroundColor),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        "${state.priorities[index].name} *",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        state.priorities[index].charge
                                                .toString() +
                                            '%',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.yellow,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: cardBackgroundColor),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Text(
                                    "${state.priorities[index].settlementDescription}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Center(
                            child: Text(
                          ' * If Payment will not settle, please wait for alteast 18 working hours',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        SizedBox(height: 20),
                        const Center(
                            child: Text(
                          ' * Working days excluded all bank holidays, all Sunday, and 2nd and 4th Saturday',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        SizedBox(height: 20),
                        const Center(
                            child: Text(
                          ' * For Amex/Diners/Business/Coporate/Dhani Pay Cards and AmazonPay additional 1% charges applicable',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        SizedBox(height: 20),
                        const Center(
                            child: Text(
                          ' * 18% GST will be applicable on convenience charges',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildLoading();
    }
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
