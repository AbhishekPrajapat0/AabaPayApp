/* Tushar Ugale * Technicul.com */
import 'dart:async';

import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_event.dart';
import 'package:aabapay_app/screens/transactions/transaction/bloc/transaction_state.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/dropdowns.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:aabapay_app/models/priority.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:fluttertoast/fluttertoast.dart';

class Transaction extends StatefulWidget {
  int orderId;
  Transaction(this.orderId);
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction>
    with TickerProviderStateMixin {
  final TransactionBloc _transactionBloc = TransactionBloc();
  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
  final DateFormat timeFormatter = DateFormat.jm();
  bool showChangePriority = true;

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
  late List<Priority> priorities;
  int priorityId = 0;
  Priority priority = Priority(
      id: 0,
      name: '',
      charge: 0,
      smallDescription: '',
      smallDescriptionFinal: '',
      bigDescription: '',
      bigDescriptionFinal: '',
      status: '',
      calculation: Calculation(
          transactionAmount: 0,
          receivableAmount: 0,
          convenienceCharges: 0,
          gst: 0,
          total: 0),
      settlementDatetime: '',
      settlementDescription: '',
      currentDate: '',
      currentTime: '',
      setPriorityTime: '',
      reducedDate: '',
      reducedTime: '');

  @override
  void initState() {
    _transactionBloc.add(TransactionLoadEvent(widget.orderId));
    // priorityId = order.priority.id;

    startTimer();
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
                        selectedIndex: 2,
                        profileUpdatedFlag: false,
                        feedbackAddedFlag: false)),
                (Route<dynamic> route) => false)),
        title: const Text("Transaction",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: BlocProvider(
        create: (_) => _transactionBloc,
        child: BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionLoadedState) {
              myDuration = Duration(
                  days: state.order.days,
                  hours: state.order.hours,
                  minutes: state.order.minutes,
                  seconds: state.order.seconds);

              countdownTimer!.cancel();
              startTimer();
            }
          },
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionInitialState ||
                  state is TransactionLoadingState) {
                return _buildLoading();
              } else {
                if (state is TransactionLoadedState) {
                  Order order = state.order;
                  priorities = state.priorities;
                  return _buildHome(context, state, order, priorities);
                }
                return _buildLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, TransactionState state, Order order,
      List<Priority> priorities) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SafeArea(
            bottom: true,
            top: true,
            child: Column(children: [
              SizedBox(height: 10),
              timer(context, state, order, priorities),
              details(context, state, order, priorities),
            ])),
      ),
    );
  }

  Widget timer(BuildContext context, TransactionState state, Order order,
      List<Priority> priorities) {
    if (myDuration.inSeconds == 0) {
      _transactionBloc.add(TransactionLoadEvent(order.id));
    }
    if (order.status == 'PROCESSING') {
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final days = strDigits(myDuration.inDays);
      final hours = strDigits(myDuration.inHours.remainder(24));
      final minutes = strDigits(myDuration.inMinutes.remainder(60));
      final seconds = strDigits(myDuration.inSeconds.remainder(60));

      if (myDuration.inMinutes <= 30) {
        // setState(() {
        //   showChangePriority = false;
        // });
      }

      return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBackgroundColor),
          padding: (order.priority.id != 1 && myDuration.inMinutes >= 30
              ? EdgeInsets.symmetric(horizontal: 15, vertical: 15)
              : EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0)),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: darkPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ' $days ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: darkPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ' $hours ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                const Text(':',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
                const SizedBox(width: 3),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: darkPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ' $minutes ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3),
                Text(':', style: TextStyle(color: Colors.white, fontSize: 30)),
                SizedBox(width: 3),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: darkPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ' $seconds ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: const Center(
                      child: Text(
                        ' Days ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: const Center(
                      child: Text(
                        ' HH ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: const Center(
                      child: Text(
                        ' MM ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: const Center(
                      child: Text(
                        ' SS ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            (order.priority.id != 1 && myDuration.inMinutes >= 30
                ? Column(
                    children: [
                      const Divider(color: Colors.grey),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                                child: const Center(
                                  child: Text(
                                    ' Transaction Priority : ',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                                child: Center(
                                  child: Text(
                                    ' ${order.priority.name} ',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: order.status.trim() == "PROCESSING" ||
                                        order.status.trim() == "PENDING"
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                priorityId = 0;
                                                priority = Priority(
                                                    id: 0,
                                                    name: '',
                                                    charge: 0,
                                                    smallDescription: '',
                                                    smallDescriptionFinal: '',
                                                    bigDescription: '',
                                                    bigDescriptionFinal: '',
                                                    status: '',
                                                    calculation: Calculation(
                                                        transactionAmount: 0,
                                                        receivableAmount: 0,
                                                        convenienceCharges: 0,
                                                        gst: 0,
                                                        total: 0),
                                                    settlementDatetime: '',
                                                    settlementDescription: '',
                                                    currentDate: '',
                                                    currentTime: '',
                                                    setPriorityTime: '',
                                                    reducedDate: '',
                                                    reducedTime: '');
                                              });
                                              confirmBox(
                                                  context, order, priorities);
                                            },
                                            child: Container(
                                                height: 25,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: lightPrimaryColor),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Change',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            lightPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      )
                                    : const SizedBox())
                          ]),
                    ],
                  )
                : Text('')),
          ]));
    }
    return SizedBox(width: 1);
  }

  Widget confirmBox(BuildContext ctx, Order order, List<Priority> priorities) {
    var pageHeight = MediaQuery.of(ctx).size.height;
    var pageWidth = MediaQuery.of(ctx).size.width;
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(const BorderSide(
            color: Colors.white, width: 0.5, style: BorderStyle.solid)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pageWidth / 25, right: pageWidth / 25),
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      onPressed: () {
        BlocProvider.of<TransactionBloc>(ctx)
            .add(TransactionConfirmPriorityEvent(priority, order));
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Priority Changed Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(lightPrimaryColor),
        overlayColor: MaterialStateProperty.all(lightPrimaryColor),
        backgroundColor: MaterialStateProperty.all(lightPrimaryColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pageWidth / 25, right: pageWidth / 25),
        child: Text(
          'Confirm',
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
          Text("Change Priority", style: TextStyle(color: lightPrimaryColor)),
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
          priorityItems.add(
            const DropdownMenuItem(
              value: 0,
              child: Text('Select Priority'),
            ),
          );
          int i = 0;

          for (Priority priority in priorities) {
            var remainingDays;
            var remainingHours;
            var remainingMinutes;
            var remainingSecs;
            // print("Set PRRiority Time :${priority.setPriorityTime}");
            // print("curr  Time :${priority.currentDate}");
            // print("reduced Time :${priority.reducedTime}");
            // print("reducedDate :${priority.reducedDate}");
            //
            Duration? totalDurationCounter;
            var allowShowTimer = true;

            //
            if (priority.currentDate.isNotEmpty &&
                priority.currentTime.isNotEmpty &&
                priority.reducedDate.isNotEmpty &&
                priority.reducedTime.isNotEmpty) {
              var currentDateTIme = DateTime.parse(
                  "${priority.currentDate} ${priority.currentTime}");
              var reducedDateTIme = DateTime.parse(
                  "${priority.reducedDate} ${priority.reducedTime}");

              var differenceBetwweenDatesInSeconds =
                  (reducedDateTIme.difference(currentDateTIme)).inSeconds;
              // print("difference in secs-- :$differenceBetwweenDatesInSeconds");
              // var showTimer =
              //     differenceBetwweenDatesInSeconds <= 0 ? false : true;
              int days = differenceBetwweenDatesInSeconds ~/ (24 * 60);
              remainingDays =
                  (reducedDateTIme.difference(currentDateTIme)).inDays;
              // Step 2: Calculate the remaining hours
              int remainingSeconds =
                  differenceBetwweenDatesInSeconds % (24 * 60 * 60);
              remainingHours = remainingSeconds ~/ (60 * 60);

              // Step 3: Calculate the remaining minutes and seconds
              remainingSeconds %= (60 * 60);
              remainingMinutes = remainingSeconds ~/ 60;
              remainingSecs = remainingSeconds % 60;

              // print(
              //     "caluculated values of time is $i :day: $remainingDays,hour : $remainingHours,mins:$remainingMinutes,secs:$remainingSecs");
              // print(
              //     "will active in :days:$remainingDays,hour:$remainingHours,,mins:$remainingMinutes");
              allowShowTimer = differenceBetwweenDatesInSeconds > 0;
              totalDurationCounter = Duration(
                days: remainingDays,
                hours: remainingHours,
                minutes: remainingMinutes,
                seconds: remainingSecs,
              );
              // print(
              //     "currDaTETIME :${DateTime.parse('${priority.currentDate} ${priority.currentTime}')} and totaldurationCounter :${totalDurationCounter}}");
              // print(
              //     "${DateTime.parse('${priority.currentDate} ${priority.currentTime}').add(totalDurationCounter!)}\nRemaining days :$remainingDays    Remaining Mins :$remainingMinutes    Remaining SEconds : $remainingSecs  and counter : ${totalDurationCounter}");
              //
              // print(
              //     "In priority ID :${priority.id}, todays DATETIME :${DateTime.parse('${priority.currentDate} ${priority.currentTime}')}  and totalDurationCounter :${totalDurationCounter.inMinutes}");
            }
            // print("ORder id  :${order.id}");

            priorityItems.add(
              DropdownMenuItem(
                enabled: priority.setPriorityTime.isNotEmpty && allowShowTimer
                    ? false
                    : true,
                value: priority.id,
                child: Row(
                  children: [
                    Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.15),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              priority.name,
                              maxLines: 7,
                            ))),
                    priority.setPriorityTime.isNotEmpty && allowShowTimer
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Row(
                              children: [
                                Text("Active in"),
                                SizedBox(
                                  width: 10,
                                ),
                                FittedBox(
                                  child: TimerCountdown(
                                    spacerWidth: 3,
                                    enableDescriptions: true,
                                    timeTextStyle: TextStyle(
                                        color: lightPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    format: CountDownTimerFormat
                                        .daysHoursMinutesSeconds,
                                    endTime: DateTime.parse(
                                            "${priority.currentDate} ${priority.currentTime}")
                                        .add(totalDurationCounter!),
                                    daysDescription: "Days",
                                    hoursDescription: "HH",
                                    minutesDescription: "MM",
                                    secondsDescription: "SS",
                                    descriptionTextStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                    onEnd: () {
                                      print("Timer finished");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            );
            i++;
          }

          return Container(
              height: height - (height * 60 / 100),
              width: width,
              child: Column(
                children: [
                  FloatingDropdownInt('', priorityItems, priorityId, (value) {
                    if (value != 0) {
                      priorityId = value!;
                      setState(() {
                        for (Priority p in priorities) {
                          if (p.id == value) {
                            priority = p;
                          }
                        }
                      });
                    } else {
                      setState(() {
                        priority = Priority(
                            id: 0,
                            name: '',
                            charge: 0,
                            smallDescription: '',
                            smallDescriptionFinal: '',
                            bigDescription: '',
                            bigDescriptionFinal: '',
                            status: '',
                            calculation: Calculation(
                                transactionAmount: 0,
                                receivableAmount: 0,
                                convenienceCharges: 0,
                                gst: 0,
                                total: 0),
                            settlementDatetime: '',
                            settlementDescription: '',
                            currentDate: '',
                            currentTime: '',
                            setPriorityTime: '',
                            reducedDate: '',
                            reducedTime: '');
                      });
                    }
                  }, ''),
                  const SizedBox(height: 8),
                  Container(
                    // padding: EdgeInsets.all(2),
                    // margin: const EdgeInsets.symmetric(vertical: 5),
                    // decoration: BoxDecoration(
                    //     color: lightBlackBackgroundColor,
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(color: benfCardBorderColor)),
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
                            Text("₹ ${priority.calculation.transactionAmount}",
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
                            Text("₹ ${priority.calculation.receivableAmount}",
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
                            Text("₹ ${priority.calculation.convenienceCharges}",
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
                            Text("₹ ${priority.calculation.gst}",
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
                            Text("₹ ${priority.calculation.total}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text("Your amount will be settled on :",
                              style: TextStyle(
                                  color: lightPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: (priority.settlementDatetime != ''
                              ? Text(
                                  dateFormatter.format(DateTime.parse(
                                              priority.settlementDatetime)
                                          .toLocal()) +
                                      " " +
                                      timeFormatter.format(DateTime.parse(
                                              priority.settlementDatetime)
                                          .toLocal()),
                                  style: TextStyle(
                                      color: lightPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))
                              : Text('')),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cancelButton,
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

  Widget details(BuildContext context, TransactionState state, Order order,
      List<Priority> priorities) {
    ThemeData themeData = Theme.of(context);
    final createdAt = DateTime.parse(order.createdAt).toLocal();
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "Status:  ",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            Text(
              "${order.getStatus()}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: order.getStatusColor(),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBackgroundColor),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Payment Method : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: lightWhiteColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${order.purpose.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.yellow,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 14,
                        color: lightWhiteColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${dateFormatter.format(createdAt)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: lightWhiteColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        size: 14,
                        color: lightWhiteColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${timeFormatter.format(createdAt)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: lightWhiteColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Beneficiary Name :",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: lightWhiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Order ID :",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: lightWhiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${order.beneficiary.account_holder_name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            order.gatewayOrderId
                                .replaceAll('order_', '')
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(255, 235, 59, 1),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              alignment: Alignment.topCenter,
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: order.gatewayOrderId
                                        .replaceAll('order_', '')
                                        .toUpperCase()));
                                Fluttertoast.showToast(
                                    msg: "Transaction ID Copied",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              },
                              icon: Icon(
                                Icons.copy,
                                size: 20,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Number :",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: lightWhiteColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${order.beneficiary.account_number}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transaction Priority :",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: lightWhiteColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${order.priority.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "IFSC :",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: lightWhiteColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${order.beneficiary.ifsc_code}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bearer :",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: lightWhiteColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${order.bearer}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Purpose :",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: lightWhiteColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${order.purpose.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              paymentSettle(order, priorities),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardBackgroundColor),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: darkPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "Paid Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        "₹ ${order.totalAmount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Convience Charges",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: lightWhiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "₹ ${order.convenience_charges}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "GST",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: lightWhiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "₹ ${order.gst}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Beneficiary Received",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: lightWhiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "₹ ${order.receivableAmount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget paymentSettle(Order order, List<Priority> priorities) {
    if (order.payoutDatetime != '') {
      final payoutDatetime = DateTime.parse(order.payoutDatetime).toLocal();
      return Column(
        children: [
          const Text(
            "Payment to be settled on ",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.green,
              fontSize: 10,
            ),
          ),
          Text(
            "${dateFormatter.format(payoutDatetime)} ${timeFormatter.format(payoutDatetime)}",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.green,
              fontSize: 10,
            ),
          ),
        ],
      );
    } else {
      return const Text('');
    }
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    if (this.mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }
}
