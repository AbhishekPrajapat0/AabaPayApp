/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/calculation.dart';
import 'package:aabapay_app/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentOptionsApi {
  var client = http.Client();
  Future<dynamic> paymentOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_OPTIONS} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_OPTIONS),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_OPTIONS} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> paymentOptionCalculation(
      int beneficiaryId,
      int purposeId,
      double transactionAmount,
      double receivableAmount,
      double convenienceCharges,
      double gst,
      double total,
      String bearer,
      int priorityId,
      int paymentOptionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": beneficiaryId,
      "purpose_id": purposeId,
      "transaction_amount": transactionAmount,
      "receivable_amount": receivableAmount,
      "convenience_charges": convenienceCharges,
      "gst": gst,
      "total_amount": total,
      "bearer": bearer,
      "priority_id": priorityId,
      "paymentoption_id": paymentOptionId,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_OPTION_CALCULATION} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL +
            AppConstants.API_PAYMENT_OPTION_CALCULATION),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_OPTION_CALCULATION} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> paymentStore(Payment payment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": payment.beneficiaryId,
      "purpose_id": payment.purposeId,
      "priority_id": payment.priorityId,
      "paymentoption_id": payment.paymentOptionId,
      "transaction_amount": payment.transactionAmount,
      "receivable_amount": payment.receivableAmount,
      "convenience_charges": payment.convenienceCharges,
      "gst": payment.gst,
      "total_amount": payment.total,
      "type": "UTILITY-PAYMENT",
      "bearer": payment.bearer
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_ORDER_NEW} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_ORDER_NEW),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_ORDER_NEW} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> paymentSuccess(String? orderId, String? paymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "order_id": orderId,
      "payment_id": paymentId,
    };
    // print("ApiService - ${AppConstants.API_PAYMENT_ORDER_NEW} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_PAYMENT_ORDER_NEW),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PAYMENT_ORDER_NEW} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
