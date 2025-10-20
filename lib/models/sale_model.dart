class SaleModel {
  final int? saleId;
  final int? visitId;
  final int? orderId;
  final int clientId;
  final int? sellerId;
  final String? saleDate;
  final int paymentType;
  final double totalPrice;
  final double totalSurcharge;
  final String status;
  final String? observations;


  SaleModel({
    required this.saleId,
    required this.visitId,
    required this.orderId,
    required this.clientId,
    required this.sellerId,
    required this.saleDate,
    required this.paymentType,
    required this.totalPrice,
    required this.totalSurcharge,
    required this.status,
    required this.observations,

  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      saleId: map['sale_id'] ?? 0,
      visitId: map['visit_id'] ?? 0,
      orderId: map['order_id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      sellerId: map['seller_id'] ?? 0,
      saleDate: map['sale_date'] ?? '',
      paymentType: map['payment_type'] ?? 0,
      totalPrice: (map['total_price'] ?? 0).toDouble(),
      totalSurcharge: (map['total_surcharge'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      observations: map['observations'] ?? '',
    );
  }
}
