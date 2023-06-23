/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationApi {
  var client = http.Client();
  Future<dynamic> verifyOtp(String mobile, String otp) async {
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "mobile": mobile,
      "otp": otp,
    };
    // print("ApiService - ${AppConstants.API_VERIFY_OTP} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_VERIFY_OTP),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_VERIFY_OTP} - ${response.body}");

    if (response.body != null) {
      var otpResponse = jsonDecode(response.body);
      if (otpResponse['message'] == 'User logged in successfully') {
        //Set Access Token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', otpResponse['access_token']);
        if (otpResponse['mpin'] != null) {
          prefs.setString('mpin', otpResponse['mpin']);
        } else {
          prefs.setString('mpin', '');
        }
      }
      return otpResponse;
    } else {
      return "";
    }
  }
}
