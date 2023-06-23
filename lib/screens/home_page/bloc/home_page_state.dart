/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/main_banner.dart';
import 'package:aabapay_app/models/mini_banner.dart';
import 'package:aabapay_app/models/order.dart';

abstract class HomePageState {}

class HomePageInitialState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  final List<MainBanner> mainBanners;
  final List<MiniBanner> miniBanners;
  final List<Order> orders;
  final String whatsappNumber;
  final String playStoreLink;
  final String youtubeLearnLink;
  HomePageLoadedState(
    this.mainBanners,
    this.miniBanners,
    this.orders,
    this.whatsappNumber,
    this.playStoreLink,
    this.youtubeLearnLink,
  );
}

class HomePageShowKycState extends HomePageState {}

class HomePageUserDeactivatedState extends HomePageState {}
