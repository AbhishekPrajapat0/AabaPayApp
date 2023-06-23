/* Tushar Ugale * Technicul.com */
class Kyc {
  final String type;
  final String status;
  final String name;
  final String number;
  final String photo1;
  final String photo2;

  Kyc(
      {required this.type,
      required this.status,
      required this.name,
      required this.number,
      required this.photo1,
      required this.photo2});

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      type: json['type'],
      status: json['status'],
      name: json['name'],
      number: json['number'],
      photo1: json['photo_1'],
      photo2: json['photo_2'],
    );
  }
}
