/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:aabapay_app/screens/utility_payment/settlement_time/settlement_time.dart';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettlementTimeApi {
  var client = http.Client();
  Future<dynamic> settlementTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_SETTLEMENT_TIME} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_SETTLEMENT_TIME),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_SETTLEMENT_TIME} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      print("----->  $jsonResponse");
      return jsonResponse;
    } else {
      return {};
    }
  }
}
