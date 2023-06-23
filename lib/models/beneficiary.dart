/* Tushar Ugale * Technicul.com */
class Beneficiary {
  final int id;
  final int user_id;
  final String account_holder_name;
  final String nickname;
  final String mobile;
  final String account_number;
  final String ifsc_code;
  final int primary;
  final String status;
  final String verificationStatus;

  Beneficiary({
    required this.id,
    required this.user_id,
    required this.account_holder_name,
    required this.nickname,
    required this.mobile,
    required this.account_number,
    required this.ifsc_code,
    required this.primary,
    required this.status,
    required this.verificationStatus,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Beneficiary(
      id: json['id'],
      user_id: json['user_id'],
      account_holder_name: json['account_holder_name'],
      nickname: json['nickname'],
      mobile: json['mobile'],
      account_number: json['account_number'],
      ifsc_code: json['ifsc_code'],
      primary: json['default'],
      status: json['status'],
      verificationStatus: (json['verification_status'] != null
          ? json['verification_status']
          : ''),
    );
  }
}
