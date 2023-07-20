/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilityPaymentApi {
  var client = http.Client();
  Future<dynamic> paymentCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_CREATE} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_CREATE),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_CREATE} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      print("----->  $jsonResponse");
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> paymentCalculation(
      String amount, String bearer, int priorityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "amount": amount,
      "bearer": bearer,
      "priority_id": priorityId
    };

    // print("ApiService - ${AppConstants.API_PAYMENT_CALCULATION} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_CALCULATION),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_CALCULATION} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> paymentCalculationValidation(
      int beneficiaryId,
      double receivableAmount,
      double convenienceCharges,
      double gst,
      double total,
      String amount,
      int purposeId,
      String bearer,
      int priorityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": beneficiaryId,
      "receivable_amount": receivableAmount,
      "convenience_charges": convenienceCharges,
      "gst": gst,
      "total_amount": total,
      "amount": amount,
      "type": "UTILITY-PAYMENT",
      "purpose_id": purposeId,
      "bearer": bearer,
      "priority_id": priorityId,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_CALCULATION_VALIDATION} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL +
            AppConstants.API_PAYMENT_CALCULATION_VALIDATION),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_CALCULATION_VALIDATION} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
