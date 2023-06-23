/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageApi {
  var client = http.Client();

  Future<dynamic> homeFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_HOME_FEED} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_HOME_FEED),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_HOME_FEED} - ${response.body}");

    if (response.statusCode == 200) {
      var homeResponse = jsonDecode(response.body);
      return homeResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> hideKyc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_HOME_HIDE_KYC} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_HOME_HIDE_KYC),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_HOME_HIDE_KYC} - ${response.body}");

    if (response.statusCode == 200) {
      var homeResponse = jsonDecode(response.body);
      return homeResponse;
    } else {
      return {};
    }
  }
}
