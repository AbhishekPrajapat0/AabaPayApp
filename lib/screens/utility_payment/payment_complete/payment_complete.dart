/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/home_page/home_page.dart';
import 'package:aabapay_app/screens/transactions/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class PaymentComplete extends StatefulWidget {
  int orderId;
  PaymentComplete(this.orderId);

  @override
  _PaymentCompleteState createState() => _PaymentCompleteState();
}

class _PaymentCompleteState extends State<PaymentComplete> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackBackgroundColor,
        body: FutureBuilder(
          future: Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Transaction(widget.orderId)),
                  (Route<dynamic> route) => false);
            },
          ),
          builder: (BuildContext context, AsyncSnapshot<Null> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/images/payment_done4.gif",
                //   height: 700,
                // ),
                Lottie.asset(
                  'assets/images/aabapay-gif.json',
                  width: 700,
                  //   height: 200,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Payment Completed',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Wait for sometime, you will be redicted to transaction',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
