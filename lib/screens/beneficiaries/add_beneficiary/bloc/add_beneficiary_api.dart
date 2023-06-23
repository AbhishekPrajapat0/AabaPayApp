/* Tushar Ugale * Technicul.com */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBeneficiaryApi {
  var client = http.Client();
  Future<dynamic> addBeneficiary(
      String accountName,
      String nickName,
      String mobile,
      String accountNumber,
      String confirmAccountNumber,
      String ifsc,
      String ifscBranch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken').toString();

    var request = {
      "authtoken": AppConstants.AUTH_TOKEN,
      "account_holder_name": accountName,
      "nickname": nickName,
      "mobile": mobile,
      "account_number": accountNumber,
      "confirm_account_number": confirmAccountNumber,
      "ifsc_code": ifsc,
      "ifsc_branch": ifscBranch,
    };

    // print("ApiService - ${AppConstants.API_ADD_BENEFICIARY} - $request");

    var response = await client.post(
        Uri.parse(AppConstants.ENV_DEV_URL + AppConstants.API_ADD_BENEFICIARY),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(request));
    // print("ApiService - ${AppConstants.API_ADD_BENEFICIARY} - ${response.body}");

    // ignore: unnecessary_null_comparison
    if (response.body != null) {
      var registerResponse = jsonDecode(response.body);
      return registerResponse;
    } else {
      return false;
    }
  }

  Future<dynamic> checkIFSC(String ifsc) async {
    if (ifsc != '') {
      var response = await client.get(
        Uri.parse("https://ifsc.razorpay.com/$ifsc"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.body != null) {
        var registerResponse = jsonDecode(response.body);
        return registerResponse;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
