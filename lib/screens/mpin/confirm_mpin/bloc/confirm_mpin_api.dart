/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmMpinApi {
  var client = http.Client();
  Future<dynamic> createMpin(String mpin, String confirmMpin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "m_pin": mpin,
      "confirm_m_pin": confirmMpin,
    };
    // print("ApiService - ${AppConstants.API_CREATE_MPIN} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_CREATE_MPIN),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_CREATE_MPIN} - ${response.body}");

    if (response.body != null) {
      var otpResponse = jsonDecode(response.body);
      return otpResponse;
    } else {
      return "";
    }
  }
}
