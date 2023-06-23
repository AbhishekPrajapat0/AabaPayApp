/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';

class LoginApi {
  var client = http.Client();

  Future<dynamic> login(String mobile) async {
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "mobile": mobile,
    };
    // print("ApiService - ${AppConstants.API_LOGIN} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_LOGIN),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_LOGIN} - ${response.body}");

    if (response.body != null) {
      var registerResponse = jsonDecode(response.body);
      return registerResponse;
    } else {
      return false;
    }
  }
}
