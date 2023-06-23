/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiariesApi {
  var client = http.Client();

  Future<dynamic> beneficiaries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
    };
    // print("ApiService - ${AppConstants.API_GET_BENEFICIARIES} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_GET_BENEFICIARIES),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_BENEFICIARIES} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> setBeneficiaryAsPrimary(int beneficiaryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": beneficiaryId,
    };

    // print("ApiService - ${AppConstants.API_SET_BENEFICIARY_AS_PRIMARY} - $request");
    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL +
            AppConstants.API_SET_BENEFICIARY_AS_PRIMARY),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_SET_BENEFICIARY_AS_PRIMARY} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> deleteBeneficiary(int beneficiaryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": beneficiaryId,
    };

    //print("ApiService - ${AppConstants.API_DELETE_BENEFICIARY} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_DELETE_BENEFICIARY),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    //print("ApiService - ${AppConstants.API_DELETE_BENEFICIARY} - ${response.body}");

    // ignore: unnecessary_null_comparison
    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> searchBeneficiaries(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {"authtoken": AppConstants.AUTH_TOKEN, "search": searchQuery};
    // print("ApiService - ${AppConstants.API_GET_BENEFICIARIES} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_GET_BENEFICIARIES),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_GET_BENEFICIARIES} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
