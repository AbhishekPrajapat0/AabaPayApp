/* Tushar Ugale * Technicul.com */
class PaymentOption {
  final int id;
  final int paymentoptioncategoryId;
  final String name;
  final String paymentGateway;
  final String smallDescription;
  final String icon;
  final String status;

  PaymentOption(
      {required this.id,
      required this.paymentoptioncategoryId,
      required this.name,
      required this.paymentGateway,
      required this.smallDescription,
      required this.icon,
      required this.status});

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
        id: json['id'],
        paymentoptioncategoryId: json['paymentoptioncategory_id'],
        name: json['name'],
        paymentGateway: json['payment_gateway'],
        smallDescription: json['small_description'],
        icon: json['icon'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentoptioncategory_id'] = this.paymentoptioncategoryId;
    data['name'] = this.name;
    data['payment_gateway'] = this.paymentGateway;
    data['small_description'] = this.smallDescription;
    data['icon'] = this.icon;
    data['status'] = this.status;
    return data;
  }
}
