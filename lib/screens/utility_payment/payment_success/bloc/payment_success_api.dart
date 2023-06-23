/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessApi {
  var client = http.Client();
  Future<dynamic> paymentSuccess(String? orderId, String? paymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "order_id": orderId,
      "payment_id": paymentId,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_PROCESSING} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_PROCESSING),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_PROCESSING} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
