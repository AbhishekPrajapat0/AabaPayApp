/* Tushar Ugale * Technicul.com */
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aabapay_app/screens/beneficiaries/beneficiaries.dart';
import 'package:aabapay_app/screens/exit-popup.dart';
import 'package:aabapay_app/screens/home_page/home_page.dart';
import 'package:aabapay_app/screens/profile/profile.dart';
import 'package:aabapay_app/screens/transactions/transactions.dart';
import 'package:aabapay_app/screens/utility_payment/payment_complete/payment_complete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aabapay_app/constants/app_colors.dart';

class Home extends StatefulWidget {
  int selectedIndex = 0;
  bool profileUpdatedFlag = false;
  bool feedbackAddedFlag = false;
  Home({
    required this.selectedIndex,
    required this.profileUpdatedFlag,
    required this.feedbackAddedFlag,
  });

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int bottomSelectedIndex = 0;
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        backgroundColor: lightBlackBackgroundColor,
        icon: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset("assets/images/home1.svg", height: 18),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        backgroundColor: lightBlackBackgroundColor,
        icon: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset("assets/images/beneficiary1.svg", height: 18),
        ),
        label: 'Beneficiaries',
      ),
      BottomNavigationBarItem(
        backgroundColor: lightBlackBackgroundColor,
        icon: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset("assets/images/transaction1.svg", height: 18),
        ),
        label: 'Transactions',
      ),
      BottomNavigationBarItem(
        backgroundColor: lightBlackBackgroundColor,
        icon: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset("assets/images/profile1.svg", height: 18),
        ),
        label: 'Account',
      ),
    ];
  }

  late PageController pageController;

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        Beneficiaries(),
        Transactions(),
        // PaymentComplete(200),
        Profile(
            profileUpdatedFlag: widget.profileUpdatedFlag,
            feedbackAddedFlag: widget.feedbackAddedFlag),
      ],
    );
  }

  @override
  void initState() {
    pageController =
        PageController(initialPage: widget.selectedIndex, keepPage: false);
    bottomSelectedIndex = widget.selectedIndex;
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: lightBlackBackgroundColor,
          currentIndex: bottomSelectedIndex,
          selectedItemColor: Color(0xFF00ceb1),
          unselectedItemColor: Color.fromARGB(255, 228, 227, 227),
          selectedLabelStyle: TextStyle(fontSize: 12, color: darkPrimaryColor),
          unselectedLabelStyle:
              const TextStyle(fontSize: 12, color: Colors.white),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }
}
