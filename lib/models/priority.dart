/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/calculation.dart';

class Priority {
  final int id;
  final String name;
  final double charge;
  final String smallDescription;
  final String smallDescriptionFinal;
  final String bigDescription;
  final String bigDescriptionFinal;
  final String status;
  final Calculation calculation;
  final String settlementDatetime;
  final String settlementDescription;

  Priority({
    required this.id,
    required this.name,
    required this.charge,
    required this.smallDescription,
    required this.smallDescriptionFinal,
    required this.bigDescription,
    required this.bigDescriptionFinal,
    required this.status,
    required this.calculation,
    required this.settlementDatetime,
    required this.settlementDescription,
  });

  factory Priority.fromJson(Map<String, dynamic> json) {
    Calculation calculationObj = Calculation(
        transactionAmount: 0,
        receivableAmount: 0,
        convenienceCharges: 0,
        gst: 0,
        total: 0);
    if (json['transaction_amount'] != null &&
        json['convenience_charges'] != null &&
        json['receivable_amount'] != null &&
        json['gst'] != null &&
        json['total'] != null) {
      calculationObj = Calculation.fromJson(json);
    }
    String settlementDatetime = '';
    if (json['settlement_datetime'] != null) {
      settlementDatetime = json['settlement_datetime'];
    }
    String big_description_final = '';
    if (json['big_description_final'] != null) {
      big_description_final = json['big_description_final'];
    }
    String small_description_final = '';
    if (json['small_description_final'] != null) {
      small_description_final = json['small_description_final'];
    }
    String settlementDescription = '';
    if (json['settlement_description'] != null) {
      settlementDescription = json['settlement_description'];
    }

    return Priority(
      id: json['id'],
      name: json['name'],
      charge: json['charge'].toDouble(),
      smallDescription: json['small_description'],
      smallDescriptionFinal: small_description_final,
      bigDescription: json['big_description'],
      bigDescriptionFinal: big_description_final,
      status: json['status'],
      calculation: calculationObj,
      settlementDatetime: settlementDatetime,
      settlementDescription: settlementDescription,
    );
  }
}
