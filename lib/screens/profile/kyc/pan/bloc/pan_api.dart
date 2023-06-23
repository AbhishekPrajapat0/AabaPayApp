/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PanApi {
  var client = http.Client();
  Future<dynamic> checkPanNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "pan_number": number,
    };
    // print("ApiService Request- ${AppConstants.KYC_PAN_CHECK} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.KYC_PAN_CHECK),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print(
    //     "ApiService Response - ${AppConstants.KYC_PAN_CHECK} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }

  Future<dynamic> sendPanPhoto(String panBase64Image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "pan_photo": panBase64Image,
    };
    print(
        "ApiService Request- ${AppConstants.KYC_PAN_PHOTO_VERIFICATION} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.KYC_PAN_PHOTO_VERIFICATION),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    print(
        "ApiService Response - ${AppConstants.KYC_PAN_PHOTO_VERIFICATION} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
