/* Tushar Ugale * Technicul.com */
class Calculation {
  final double transactionAmount;
  final double receivableAmount;
  final double convenienceCharges;
  final double gst;
  final double total;

  Calculation(
      {required this.transactionAmount,
      required this.receivableAmount,
      required this.convenienceCharges,
      required this.gst,
      required this.total});

  factory Calculation.fromJson(Map<String, dynamic> json) {
    return Calculation(
      transactionAmount: json['transaction_amount'].toDouble(),
      receivableAmount: json['receivable_amount'].toDouble(),
      convenienceCharges: json['convenience_charges'].toDouble(),
      gst: json['gst'].toDouble(),
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_amount'] = transactionAmount;
    data['receivable_amount'] = receivableAmount;
    data['convenience_charges'] = convenienceCharges;
    data['gst'] = gst;
    data['total'] = total;
    return data;
  }
}
