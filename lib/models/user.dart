/* Tushar Ugale * Technicul.com */
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String pincode;
  final String reference;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.pincode,
    required this.reference,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      email: json['email'],
      pincode: json['pincode'],
      reference: json['reference'],
    );
  }
}
