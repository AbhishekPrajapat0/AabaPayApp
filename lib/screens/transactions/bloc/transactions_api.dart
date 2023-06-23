/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsApi {
  var client = http.Client();
  Future<dynamic> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_GET_TRANSACTIONS} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_GET_TRANSACTIONS),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_TRANSACTIONS} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> searchTransactions(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {"authtoken": AppConstants.AUTH_TOKEN, "search": searchQuery};
    // print("ApiService - ${AppConstants.API_GET_TRANSACTIONS} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_GET_TRANSACTIONS),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_TRANSACTIONS} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
