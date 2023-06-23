/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/payment_option.dart';

class PaymentOptionCategory {
  bool isExpanded;
  final int id;
  final String name;
  final String icon;
  final String status;
  final List<PaymentOption> paymentOptions;

  PaymentOptionCategory(
      {required this.id,
      required this.isExpanded,
      required this.name,
      required this.icon,
      required this.status,
      required this.paymentOptions});

  factory PaymentOptionCategory.fromJson(Map<String, dynamic> json) {
    return PaymentOptionCategory(
        id: json['id'],
        isExpanded: false,
        name: json['name'],
        icon: json['icon'],
        status: json['status'],
        paymentOptions: (json['payment_options'] != ''
            ? List<PaymentOption>.from(json['payment_options']
                .map((model) => PaymentOption.fromJson(model))).toList()
            : []));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['status'] = this.status;
    data['payment_options'] = this.paymentOptions;
    return data;
  }
}
