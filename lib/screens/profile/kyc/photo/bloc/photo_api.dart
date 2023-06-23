/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoApi {
  var client = http.Client();
  Future<dynamic> checkPhoto(String photo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "photo": photo,
    };
    print("ApiService Request- ${AppConstants.KYC_PHOTO_CHECK} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.KYC_PHOTO_CHECK),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    print(
        "ApiService Response - ${AppConstants.KYC_PHOTO_CHECK} - ${response.body}");

    if (response.body != null) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {};
    }
  }
}
