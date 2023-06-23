/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar.dart';
import 'package:aabapay_app/screens/transactions/transaction/transaction.dart';
import 'package:aabapay_app/screens/utility_payment/settlement_time/settlement_time.dart';
import 'package:aabapay_app/screens/utility_payment/utility_payment.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_bloc.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_state.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_event.dart';
import 'package:aabapay_app/models/main_banner.dart';
import 'package:aabapay_app/models/mini_banner.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletons/skeletons.dart' hide Shimmer;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageBloc _homePageBloc = HomePageBloc();
  final CarouselController _controller = CarouselController();
  final CarouselController _controller2 = CarouselController();
  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
  final DateFormat timeFormatter = DateFormat.jm();
  String whatsappNumber = '';
  String playStoreLink = '';
  String youtubeLearnLink = '';
  int showKyc = 100;

  Future<void> share() async {
    await FlutterShare.share(
        title: 'AabaPay Pvt Ltd',
        text: 'AabaPay Play Store',
        linkUrl: playStoreLink,
        chooserTitle: '');
  }

  @override
  void initState() {
    _homePageBloc.add(HomePageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: Shimmer.fromColors(
          baseColor: lightPrimaryColor,
          highlightColor: Colors.blue,
          direction: ShimmerDirection.ltr,
          period: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: SvgPicture.asset(
              "assets/images/logo.svg",
            ),
          ),
        ),
        title: const Text("AabaPay",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 26)),
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
          create: (_) => _homePageBloc,
          child: BlocListener<HomePageBloc, HomePageState>(
            listener: (context, state) {
              if (state is HomePageShowKycState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Aadhar(skipKyc: true)),
                    (Route<dynamic> route) => false);
              }
              if (state is HomePageUserDeactivatedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Login(forgotMpinFlag: false)),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageInitialState) {
                  return _buildLoading();
                } else {
                  if (state is HomePageLoadedState) {
                    whatsappNumber = state.whatsappNumber;
                    playStoreLink = state.playStoreLink;
                    youtubeLearnLink = state.youtubeLearnLink;
                  }
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, HomePageState state) {
    return SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                mainSlider(context, state),
                const SizedBox(height: 30),
                mainIcons(),
                const SizedBox(height: 25),
                miniSlider(context, state),
                const SizedBox(height: 20),
                transactionHeader(),
                const SizedBox(height: 5),
                transactions(context, state),
              ]),
            ))
          ],
        ));
  }

  Widget mainSlider(BuildContext context, HomePageState state) {
    if (state is HomePageLoadedState) {
      List<Container> mainBanners = [];
      for (MainBanner banner in state.mainBanners) {
        Container container = Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(5)),
            child: GestureDetector(
              onTap: () {
                launch(banner.link);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(banner.imagePath, fit: BoxFit.cover)),
            ));
        mainBanners.add(container);
      }

      return CarouselSlider(
        carouselController: _controller2,
        options: CarouselOptions(
          height: 165.0,
          autoPlayAnimationDuration: Duration(milliseconds: 1500),
          autoPlay: true,
          viewportFraction: 0.9,
        ),
        items: mainBanners,
      );

      //   List<Image> mainBanners = [];
      //   for (MainBanner banner in state.mainBanners) {
      //     mainBanners.add(Image.network(banner.imagePath, fit: BoxFit.cover));
      //   }
      //   return CarouselSlider(
      //     options: CarouselOptions(
      //       height: 165.0,
      //       autoPlay: true,
      //       autoPlayAnimationDuration: Duration(milliseconds: 1500),
      //     ),
      //     items: mainBanners.map((i) {
      //       return Builder(
      //         builder: (BuildContext context) {
      //           return Container(
      //               width: MediaQuery.of(context).size.width + 100,
      //               margin: EdgeInsets.symmetric(horizontal: 5.0),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(5),
      //               ),
      //               child: i);
      //         },
      //       );
      //     }).toList(),
      //   );
      //   return CarouselSlider(
      //     carouselController: _controller,
      //     options: CarouselOptions(
      //       height: 165.0,
      //       autoPlay: true,
      //       autoPlayAnimationDuration: Duration(milliseconds: 1500),
      //       viewportFraction: 0.9,
      //       onPageChanged: (index, reason) {},
      //     ),
      //     items: mainBanners,
      //   );
    } else {
      return Center(
          child: Container(
              height: 165.0,
              width: 380.0,
              decoration: BoxDecoration(
                  color: lightWhiteColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              )));
    }
  }

  Widget miniSlider(BuildContext context, HomePageState state) {
    if (state is HomePageLoadedState) {
      List<Container> miniBanners = [];
      for (MiniBanner banner in state.miniBanners) {
        Container container = Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(5)),
            child: GestureDetector(
              onTap: () {
                launch(banner.link);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(banner.imagePath, fit: BoxFit.cover)),
            ));
        miniBanners.add(container);
      }
      return CarouselSlider(
        carouselController: _controller2,
        options: CarouselOptions(
          height: 90.0,
          autoPlayAnimationDuration: Duration(milliseconds: 2000),
          autoPlay: true,
          viewportFraction: 0.65,
        ),
        items: miniBanners,
      );
    } else {
      return Center(
          child: Container(
              height: 90.0,
              width: 247.0,
              decoration: BoxDecoration(
                  color: lightWhiteColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              )));
    }
  }

  Widget mainIcons() {
    return Container(
      height: 160,
      child: GridView.count(
        crossAxisCount: 3,
        // controller: scrollController,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        mainAxisSpacing: 0.5,
        crossAxisSpacing: 40.0,
        children: [
          InkWell(
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
                  builder: (context) => UtilityPayment(
                        payment,
                        beneficiaryAddskipped: false,
                      )));
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/utility_payment.svg",
                      height: 24, width: 24),
                  SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Utility\nPayment",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 2,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)));
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/transaction_history.svg",
                      height: 24, width: 24),
                  SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Transaction\nHistory",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 1,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)));
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/Beneficiary.svg",
                      height: 30, width: 30),
                  SizedBox(height: 5),
                  const Text(
                    "Beneficiaries",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              String url = "https://wa.me/91" +
                  whatsappNumber +
                  "?text=Please help me with my transactions";
              launch(url);
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/chat.svg",
                      height: 24, width: 24),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Chat",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              share();
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/share.svg",
                      height: 24, width: 24),
                  SizedBox(height: 10),
                  const Text(
                    "Share",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              launch(youtubeLearnLink);
            },
            child: Container(
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/learn.svg",
                      height: 24, width: 24),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Learn",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Transactions",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16)),
          GestureDetector(
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 2,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)))
            },
            child: Text("View all",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget transactions(BuildContext context, HomePageState state) {
    if (state is HomePageLoadedState) {
      if (state.orders.length != null) {
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: state.orders.length,
            // controller: scrollController,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final createdAt =
                  DateTime.parse(state.orders[index].createdAt).toLocal();
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Transaction(state.orders[index].id)));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: lightBlackBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: benfCardBorderColor)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${state.orders[index].beneficiary.account_holder_name}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          Text("\₹ ${state.orders[index].totalAmount}",
                              style: TextStyle(
                                  color: amountColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "A/C ${state.orders[index].beneficiary.account_number}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          Text("${dateFormatter.format(createdAt)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${state.orders[index].getStatus()}",
                              style: TextStyle(
                                  color: state.orders[index].getStatusColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          Text("${timeFormatter.format(createdAt)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return _buildLoading();
      }
    } else {
      return _buildLoading();
    }
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
