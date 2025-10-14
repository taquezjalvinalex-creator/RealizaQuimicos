class PaymentModel {
  final int? paymentId;
  final int? creditId;
  final int? saleId;
  final int? sellerId;
  final int? methodId;
  final double amount;
  final double? remaining;
  final String? receipt; //photo recipe
  final String paymentDate;
  final String? observation;

  PaymentModel({
    required this.paymentId,
    required this.creditId,
    required this.saleId,
    required this.sellerId,
    required this.methodId,
    required this.amount,
    required this.remaining,
    required this.receipt,
    required this.paymentDate,
    required this.observation,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      paymentId: map['payment_id'] ?? 0,
      creditId: map['credit_id'] ?? 0,
      saleId: map['sale_id'] ?? 0,
      sellerId: map['seller_id'] ?? 0,
      methodId: map['payment_method_id'] ?? 0,
      amount: (map['amount_paid'] ?? 0).toDouble(),
      remaining: (map['remaining_balance'] ?? 0).toDouble(),
      receipt: map['payment_receipt'] ?? '',
      paymentDate: map['payment_date'] ?? '',
      observation: map['observations'] ?? '',

    );
  }
}
