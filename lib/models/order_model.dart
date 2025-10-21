class OrderModel {
  final int? orderId;
  final int clientId;
  final String? clientName;
  final String? clientLastName;
  final int sellerId;
  final String? sellerName;
  final String? sellerLastName;
  final String status;
  final String orderDate;
  final int quantity;
  final double totalPrice;
  final double totalSurcharge;
  final String observations;

  OrderModel({
    required this.orderId,
    required this.clientId,
    required this.clientName,
    required this.clientLastName,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLastName,
    required this.status,
    required this.orderDate,
    required this.quantity,
    required this.totalPrice,
    required this.totalSurcharge,
    required this.observations,
  });

  // Convertir desde Map (resultado de SQLite) a OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['order_id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      clientName: map['client_name'] ?? '',
      clientLastName: map['client_last_name'] ?? '',
      sellerId: map['seller_id'] ?? 0,
      status: map['status'] ?? '',
      sellerName: map['seller_name'] ?? '',
      sellerLastName: map['seller_last_name'] ?? '',
      orderDate: map['order_date'] ?? '',
      quantity: (map['total_quantity'] ?? 0),
      totalPrice: (map['total_price'] ?? 0).toDouble(),
      totalSurcharge: (map['total_surcharge'] ?? 0).toDouble(),
      observations: map['observations'] ?? '',
    );
  }
}
