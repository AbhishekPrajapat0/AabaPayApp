/* Tushar Ugale * Technicul.com */
class Ifsc {
  final String BRANCH;
  final String ADDRESS;
  final String MICR;
  final String CITY;
  final String DISTRICT;

  Ifsc(
      {required this.BRANCH,
      required this.ADDRESS,
      required this.MICR,
      required this.CITY,
      required this.DISTRICT});

  factory Ifsc.fromJson(Map<String, dynamic> json) {
    return Ifsc(
      BRANCH: json['BRANCH'],
      ADDRESS: json['ADDRESS'],
      MICR: json['MICR'],
      CITY: json['CITY'],
      DISTRICT: json['DISTRICT'],
    );
  }
}
