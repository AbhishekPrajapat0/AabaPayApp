/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:aabapay_app/models/order.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionApi {
  var client = http.Client();
  Future<dynamic> getOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "order_id": orderId,
    };
    // print("ApiService - ${AppConstants.API_GET_TRANSACTION} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_GET_TRANSACTION),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_TRANSACTION} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> getPriorities(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "order_id": orderId,
    };
    // print("ApiService - ${AppConstants.API_GET_TRANSACTION_PRIORITIES} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL +
            AppConstants.API_GET_TRANSACTION_PRIORITIES),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_TRANSACTION_PRIORITIES} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      // print(
      //     "response of transaction prirites  : Delete this later : ${response.body}");
      print("----->  $jsonResponse");
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> updatePriorityInOrder(Priority priority, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "order_id": order.id,
      "priority_id": priority.id,
      "transaction_amount": priority.calculation.transactionAmount,
      "receivable_amount": priority.calculation.receivableAmount,
      "convenience_charges": priority.calculation.convenienceCharges,
      "gst": priority.calculation.gst,
      "total": priority.calculation.total,
      "payout_datetime": priority.settlementDatetime,
    };
    // print("ApiService - ${AppConstants.API_UPDATE_PRIORITY_IN_ORDER} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL +
            AppConstants.API_UPDATE_PRIORITY_IN_ORDER),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_UPDATE_PRIORITY_IN_ORDER} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      print("----->  $jsonResponse");
      return jsonResponse;
    } else {
      return {};
    }
  }
}
