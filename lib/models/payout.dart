/* Tushar Ugale * Technicul.com */
class Payout {
  final int id;
  final int orderId;
  final String gatewayPayoutId;
  final double amount;
  final String status;
  final String createdAt;

  Payout({
    required this.id,
    required this.orderId,
    required this.gatewayPayoutId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Payout.fromJson(json) {
    if (json != null) {
      return Payout(
        id: json['id'],
        orderId: json['order_id'],
        gatewayPayoutId: json['gateway_payout_id'],
        amount: json['amount'].toDouble(),
        status: json['status'],
        createdAt: json['created_at'],
      );
    } else {
      return Payout(
        id: 0,
        orderId: 0,
        gatewayPayoutId: '',
        amount: 0,
        status: '',
        createdAt: '',
      );
    }
  }
}
