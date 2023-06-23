/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_bloc.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_event.dart';
import 'package:aabapay_app/screens/transactions/bloc/transactions_state.dart';
import 'package:aabapay_app/screens/transactions/transaction/transaction.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/settlement_time.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/constants/app_constants.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final TransactionsBloc _transactionsBloc = TransactionsBloc();
  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
  final DateFormat timeFormatter = DateFormat.jm();
  List<Order> orders = [];
  String _filterValueSelected = '';

  @override
  void initState() {
    print(1);
    _transactionsBloc.add(TransactionsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text("Transactions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettlementTime()));
              },
              icon: const Icon(Icons.info, size: 24, color: Colors.white)),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _transactionsBloc,
          child: BlocListener<TransactionsBloc, TransactionsState>(
            listener: (context, state) {},
            child: BlocBuilder<TransactionsBloc, TransactionsState>(
              builder: (context, state) {
                if (state is TransactionsInitialState ||
                    state is TransactionsLoadingState) {
                  return _buildLoading();
                } else {
                  if (state is TransactionsLoadedState) {
                    orders = state.orders;
                    _filterValueSelected = state.filterValue;
                    return _buildHome(context);
                  } else {
                    return _buildLoading();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(
    BuildContext context,
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
                  search(context),
                  const SizedBox(height: 10),
                  transactions(),
                ],
              ),
            ),
          ])),
    );
  }

  Widget search(BuildContext ctx) {
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
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
              onChanged: (searchQuery) {
                BlocProvider.of<TransactionsBloc>(ctx)
                    .add(SearchTransactionsEvent(searchQuery));
              },
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              filterModal(ctx);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: darkPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 24),
            ),
          )
        ],
      ),
    );
  }

  filterModal(BuildContext ctx) {
    double pageHeight = MediaQuery.of(ctx).size.height;
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => FractionallySizedBox(
              heightFactor: 0.6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: cardBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter By',
                            style: TextStyle(
                                color: lightPrimaryColor, fontSize: 15)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = '';
                            });
                            BlocProvider.of<TransactionsBloc>(ctx).add(
                                TransactionsFilterEvent(_filterValueSelected));
                            Navigator.pop(context);
                          },
                          child: Text('Clear',
                              style: TextStyle(
                                  color: lightPrimaryColor, fontSize: 15)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'PROCESSING',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'PROCESSING';
                            });
                          },
                          child: const Text('Processing',
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'COMPLETED',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'COMPLETED';
                            });
                          },
                          child: const Text('Completed',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'FAILED',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'FAILED';
                            });
                          },
                          child: const Text('Failed',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'CANCELLED',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'CANCELLED';
                            });
                          },
                          child: const Text('Changed (Cancelled)',
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'HOLD-PAYMENT',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'HOLD-PAYMENT';
                            });
                          },
                          child: const Text('On - Hold',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  ', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(lightPrimaryColor),
                            value: 'REFUNDED',
                            onChanged: (value) {
                              setState(() {
                                _filterValueSelected = value!;
                              });
                            },
                            groupValue: _filterValueSelected),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterValueSelected = 'REFUNDED';
                            });
                          },
                          child: const Text('Refunded',
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 15)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      "Apply",
                      () {
                        Navigator.pop(context);

                        BlocProvider.of<TransactionsBloc>(ctx)
                            .add(TransactionsFilterEvent(_filterValueSelected));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget transactions() {
    return ListView.builder(
      itemCount: orders.length,
      // controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Icon icon = Icon(Icons.abc);
        if (orders[index].status == 'PENDING') {
          icon = Icon(Icons.hourglass_empty_rounded, color: Colors.amber);
        }
        if (orders[index].status == 'PROCESSING') {
          icon = Icon(Icons.timelapse, color: Colors.orange);
        }
        if (orders[index].status == 'FAILED') {
          icon = Icon(Icons.highlight_off, color: Colors.red);
        }
        if (orders[index].status == 'HOLD-PAYMENT') {
          icon = Icon(Icons.pause_circle, color: Colors.white);
        }
        if (orders[index].status == 'COMPLETED') {
          icon = Icon(Icons.check_circle, color: Colors.green);
        }
        if (orders[index].status == 'CANCELLED') {
          icon = Icon(Icons.manage_history, color: Colors.yellow);
        }
        if (orders[index].status == 'REFUNDED') {
          icon = Icon(Icons.arrow_circle_up, color: HexColor('975AFF'));
        }
        final createdAt = DateTime.parse(orders[index].createdAt).toLocal();
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Transaction(orders[index].id)));
          },
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: cardHeaderBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8)),
                    // border: Border.fromBorderSide(side)
                    border: Border.all(color: benfCardBorderColor)),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                            "Order ID - " +
                                orders[index]
                                    .gatewayOrderId
                                    .replaceAll('order_', '')
                                    .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      icon,
                    ],
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.all(10),
                // margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: lightBlackBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: Border.all(color: benfCardBorderColor)),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              orders[index].beneficiary.account_holder_name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text("₹ ${orders[index].totalAmount}",
                            style: TextStyle(
                                color: amountColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('A/C ' + orders[index].beneficiary.account_number,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        Text(""),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(orders[index].purpose.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        Text(dateFormatter.format(createdAt),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${orders[index].getStatus()}",
                            style: TextStyle(
                                color: orders[index].getStatusColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        Text("${timeFormatter.format(createdAt)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
