/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditBeneficiaryApi {
  var client = http.Client();
  Future<dynamic> editBeneficiary(
      int id,
      String accountName,
      String nickName,
      String mobile,
      String accountNumber,
      String confirmAccountNumber,
      String ifsc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "beneficiary_id": id.toString(),
      "account_holder_name": accountName,
      "nickname": nickName,
      "mobile": mobile,
      "account_number": accountNumber,
      "confirm_account_number": confirmAccountNumber,
      "ifsc_code": ifsc,
    };

    // print("ApiService - ${AppConstants.API_UPDATE_BENEFICIARY} - $request");

    var response = await client.post(
        Uri.parse(
            AppConstants.ENV_DEV_URL + AppConstants.API_UPDATE_BENEFICIARY),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_UPDATE_BENEFICIARY} - ${response.body}");

    // ignore: unnecessary_null_comparison
    if (response.body != null) {
      var registerResponse = jsonDecode(response.body);
      return registerResponse;
    } else {
      return false;
    }
  }
}
