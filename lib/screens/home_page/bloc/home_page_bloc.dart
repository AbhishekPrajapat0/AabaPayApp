/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_event.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_state.dart';
import 'package:aabapay_app/screens/home_page/bloc/home_page_api.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/models/main_banner.dart';
import 'package:aabapay_app/models/mini_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final HomePageApi homePageApi = HomePageApi();

  HomePageBloc() : super(HomePageInitialState()) {
    on<HomePageLoadEvent>((event, emit) async {
      emit(HomePageLoadingState());
      await homePageApi.homeFeed().then((value) async {
        print(value);
        List<MainBanner> mainBanners = List<MainBanner>.from(
                value['banners'].map((model) => MainBanner.fromJson(model)))
            .toList();

        List<MiniBanner> miniBanners = List<MiniBanner>.from(
            value['mini_banners']
                .map((model) => MiniBanner.fromJson(model))).toList();

        List<Order> orders = List<Order>.from(
            value['orders'].map((model) => Order.fromJson(model))).toList();

        String whatsappNumber = value['whatsapp_number'];
        String playStoreLink = value['playstore_link'];
        String youtubeLearnLink = value['youtube_learn_link'];
        int showKyc = value['show_kyc'];
        String userStatus = value['user_status'];
        if (userStatus == 'DEACTIVE') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', '');
          emit(HomePageUserDeactivatedState());
        }

        if (showKyc == 0) {
          await homePageApi.hideKyc().then((value) {
            emit(HomePageShowKycState());
          });
        }

        emit(HomePageLoadedState(mainBanners, miniBanners, orders,
            whatsappNumber, playStoreLink, youtubeLearnLink));
      });
    });
  }
}
