/* Tushar Ugale * Technicul.com */
class Payment {
  final int beneficiaryId;
  final double transactionAmount;
  final double receivableAmount;
  final double convenienceCharges;
  final double gst;
  final double total;
  final int purposeId;
  final String bearer;
  final int priorityId;
  final int paymentOptionId;
  final String paymentOptionDesc;

  Payment({
    required this.beneficiaryId,
    required this.transactionAmount,
    required this.receivableAmount,
    required this.convenienceCharges,
    required this.gst,
    required this.total,
    required this.purposeId,
    required this.bearer,
    required this.priorityId,
    required this.paymentOptionId,
    required this.paymentOptionDesc,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      beneficiaryId: json['beneficiary_id'],
      transactionAmount: json['transaction_amount'].toDouble(),
      receivableAmount: json['receivable_amount'].toDouble(),
      convenienceCharges: json['convenience_charges'].toDouble(),
      gst: json['gst'].toDouble(),
      total: json['total'].toDouble(),
      purposeId: json['purpose_id'],
      bearer: json['bearer'],
      priorityId: json['priority_id'],
      paymentOptionId: json['paymentoption_id'],
      paymentOptionDesc: json['paymentoption_desc'],
    );
  }
}
