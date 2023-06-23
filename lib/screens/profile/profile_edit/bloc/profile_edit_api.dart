/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditApi {
  var client = http.Client();
  Future<dynamic> updateProfile(
      String firstName, String lastName, String email, String pincode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "pincode": pincode,
    };
    // print("ApiService - ${AppConstants.API_PROFILE_UPDATE} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_PROFILE_UPDATE),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_PROFILE_UPDATE} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
