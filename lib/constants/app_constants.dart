/* Tushar Ugale * Technicul.com */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  /* API Url*/
  static final String ENV_DEV_URL = "https://aabapay.com/";

  static final String TERMS_URL = 'https://aabapay.com/terms-of-service';
  static final String PRIVACY_URL = 'https://aabapay.com/privacy-policy';
  static final String ABOUT_URL = 'https://aabapay.com/';
  static final String CONTACT_URL = 'https://aabapay.com/contact';

  /* Auth token*/

  /* Auth token*/
  /* Auth token*/

  static final String AUTH_TOKEN = "1234";

  /* Filters */
  static const String PAGE_LENGTH = "10";
  static const String ORDER_BY_DESC = "DESC";
  static const String ORDER_BY_ASC = "ASC";
  static const String SORT_BY_ID = "id";
  static const String SORT_BY_CREATED_AT = "created_at";

  /* API method names*/
  static final String API_LOGIN = "login";
  static final String API_REGISTER = "register";
  static final String API_VERIFY_OTP = "verify-otp";
  static final String API_HOME_FEED = "home";
  static final String API_HOME_HIDE_KYC = "home/hide-kyc";
  static final String API_USER_DETAILS = "my-account";
  static final String API_GET_BENEFICIARIES = "beneficiaries";
  static final String API_ADD_BENEFICIARY = "beneficiaries/store";
  static final String API_UPDATE_BENEFICIARY = "beneficiaries/update";
  static final String API_DELETE_BENEFICIARY = "beneficiaries/delete";
  static final String API_SET_BENEFICIARY_AS_PRIMARY =
      "beneficiaries/set-default";
  static final String API_PAYMENT_CREATE = "payments/create";
  static final String API_PAYMENT_CALCULATION = "payments/calculation";
  static final String API_SETTLEMENT_TIME = "payments/settlement-time";
  static final String API_PAYMENT_OPTIONS =
      "payments/payment-option-categories";
  static final String API_PAYMENT_CALCULATION_VALIDATION =
      "payments/calculation-validation";
  static final String API_PAYMENT_OPTION_CALCULATION =
      "payments/payment-option-calculation";
  static final String API_PAYMENT_ORDER_NEW = "payments/order/new";
  static final String API_PAYMENT_PROCESSING = "payments/order/processing";
  static final String API_GET_TRANSACTIONS = "transactions";

  static final String API_GET_TRANSACTION = "transactions/transaction";
  static final String API_GET_TRANSACTION_PRIORITIES = "transaction/priorities";
  static final String API_UPDATE_PRIORITY_IN_ORDER =
      "transaction/priority/update";

  static final String API_MY_ACCOUNT = "my-account";
  static final String API_PROFILE_UPDATE = "profile/update";
  static final String API_SUBMIT_FEEDBACK = "feedback/store";

  static final String API_CREATE_MPIN = "create/m-pin";

  static final String API_DELETE_ACCOUNT = "delete-account";

  static final String KYC_STATUS = "kyc/get-status";
  static final String KYC_AADHAR_SEND_OTP = "kyc/aadhar/send-otp";
  static final String KYC_AADHAR_CHECK_OTP = "kyc/aadhar/check-otp";
  static final String KYC_AADHAR_PHOTO_VERIFICATION = "kyc/aadhar/photo-verify";

  static final String KYC_PAN_CHECK = "kyc/pan/check";
  static final String KYC_PAN_PHOTO_VERIFICATION = "kyc/pan/photo-verify";

  static final String KYC_PHOTO_CHECK = "kyc/photo/check";

  static final TextCapitalization CAPTIAL_WORDS = TextCapitalization.words;
  static final TextCapitalization CAPTIAL_SENTENCES =
      TextCapitalization.sentences;
  static final TextCapitalization CAPTIAL_ALL = TextCapitalization.characters;

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
