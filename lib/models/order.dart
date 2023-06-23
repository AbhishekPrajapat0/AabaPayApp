/* Tushar Ugale * Technicul.com */
import 'dart:ui';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/models/beneficiary.dart';
import 'package:aabapay_app/models/payment_option.dart';
import 'package:aabapay_app/models/payout.dart';
import 'package:aabapay_app/models/priority.dart';
import 'package:aabapay_app/models/purpose.dart';

class Order {
  final int id;
  final int userId;
  final Beneficiary beneficiary;
  final Purpose purpose;
  final Priority priority;
  final PaymentOption paymentOption;
  final double transactionAmount;
  final double receivableAmount;
  final double convenience_charges;
  final double gst;
  final double totalAmount;
  final String bearer;
  final String status;
  final String createdAt;
  final String gatewayPaymentId;
  final String gatewayOrderId;
  final String payoutDatetime;
  final Payout payout;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  Order({
    required this.id,
    required this.userId,
    required this.beneficiary,
    required this.purpose,
    required this.priority,
    required this.paymentOption,
    required this.transactionAmount,
    required this.receivableAmount,
    required this.convenience_charges,
    required this.gst,
    required this.totalAmount,
    required this.bearer,
    required this.status,
    required this.createdAt,
    required this.gatewayPaymentId,
    required this.gatewayOrderId,
    required this.payoutDatetime,
    required this.payout,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      beneficiary: Beneficiary.fromJson(json['beneficiary_data']),
      purpose: Purpose.fromJson(json['purpose_data']),
      priority: Priority.fromJson(json['priority_data']),
      paymentOption: PaymentOption.fromJson(json['paymentoption_data']),
      transactionAmount: json['transaction_amount'].toDouble(),
      receivableAmount: json['receivable_amount'].toDouble(),
      convenience_charges: json['convenience_charges'].toDouble(),
      gst: json['gst'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      bearer: json['bearer'],
      status: json['status'],
      createdAt: json['created_at'],
      gatewayPaymentId: json['gateway_payment_id'],
      gatewayOrderId: json['gateway_order_id'],
      payoutDatetime: json['payout_datetime'],
      payout: Payout.fromJson(json['payout']),
      days: json['days'],
      hours: json['hours'],
      minutes: json['minutes'],
      seconds: json['seconds'],
    );
  }

  String getStatus() {
    if (this.status == 'PENDING') {
      return 'Pending';
    }
    if (this.status == 'PROCESSING') {
      return 'Processing';
    }
    if (this.status == 'FAILED') {
      return 'Failed';
    }
    if (this.status == 'HOLD-PAYMENT') {
      return 'On-Hold';
    }
    if (this.status == 'COMPLETED') {
      return 'Completed';
    }
    if (this.status == 'CANCELLED') {
      return 'Cancelled (Changed)';
    }
    if (this.status == 'REFUNDED') {
      return 'Refunded';
    }
    return '';
  }

  Color getStatusColor() {
    if (this.status == 'PENDING') {
      return orangeColor;
    }
    if (this.status == 'PROCESSING') {
      return orangeColor;
    }
    if (this.status == 'FAILED') {
      return redColor;
    }
    if (this.status == 'HOLD-PAYMENT') {
      return lightWhiteColor;
    }
    if (this.status == 'COMPLETED') {
      return successColor;
    }
    if (this.status == 'CANCELLED') {
      return yellowColor;
    }
    if (this.status == 'REFUNDED') {
      return purpleColor;
    }
    return orangeColor;
  }
}
