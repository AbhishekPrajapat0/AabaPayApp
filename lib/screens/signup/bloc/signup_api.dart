/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';

class SignUpApi {
  var client = http.Client();
  Future<dynamic> register(String firstName, String lastName, String mobile,
      String email, String pincode, String reference) async {
    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "email": email,
      "pincode": pincode,
      "reference": reference,
    };
    // print("ApiService - ${AppConstants.API_REGISTER} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_REGISTER),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_REGISTER} - ${response.body}");

    if (response.body != null) {
      var registerResponse = jsonDecode(response.body);
      return registerResponse;
    } else {
      return false;
    }
  }
}
