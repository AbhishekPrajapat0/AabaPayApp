/* Tushar Ugale * Technicul.com */
import 'dart:async';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/models/SlidingItems.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  // final controller = PageController(viewportFraction: 0.8, keepPage: true);

  int _currentPage = 0;
  final PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (controller.hasClients) {
        controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
      3,
      (index) => Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: SvgPicture.asset(
                slideList[index].imageUrl,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Text(
                slideList[index].title,
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Center(
                child: Text(
                  slideList[index].description,
                  style: TextStyle(
                      color: lightWhiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 45,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/Textlogo.png',
                  height: 30,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                itemBuilder: (_, index) {
                  return pages[index % pages.length];
                },
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: WormEffect(
                activeDotColor: lightGreenTextColor,
                dotColor: lightWhiteColor,
                dotHeight: 6,
                dotWidth: 10,
                type: WormType.thin,
                // strokeWidth: 5,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: lightBlackColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: lightGreenTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 88.0,
                            minHeight: 45.0,
                          ), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: Login(forgotMpinFlag: false),
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.fade,
                        //     child: const Login(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 17, right: 17),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: SignUp(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: greenTextColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New user ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Create  an Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: greenTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const colors = [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];
