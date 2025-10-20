class CreditModel {
  final int creditId;
  final int saleId;
  final int clientId;
  final int sellerId;
  final double totalAmount;
  final double totalSurcharge;
  final double outstandingBalance;
  final String startDate;
  final String dueDate;
  final int status;
  final String observations;

  CreditModel({
    required this.creditId,
    required this.saleId,
    required this.clientId,
    required this.sellerId,
    required this.totalAmount,
    required this.totalSurcharge,
    required this.outstandingBalance,
    required this.startDate,
    required this.dueDate,
    required this.status,
    required this.observations,
  });

  // Convertir desde Map (resultado de SQLite) a CreditModel
  factory CreditModel.fromMap(Map<String, dynamic> map) {
    return CreditModel(
      creditId: map['client_id'] ?? 0,
      saleId: map['sale_id'] ?? 0,
      clientId: map['client_name'] ?? 0,
      sellerId: map['seller_id'] ?? 0,
      totalAmount: (map['total_amount'] ?? 0).toDouble(),
      totalSurcharge: (map['total_surcharge'] ?? 0).toDouble(),
      outstandingBalance: (map['outstanding_balance'] ?? 0).toDouble(),
      startDate: map['start_date'] ?? '',
      dueDate: map['due_date'] ?? '',
      status: map['status'] ?? 0,
      observations: map['observations'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credit_id': creditId, // Si es null, sqflite lo ignora y autoincrementa
      'sale_id': saleId,
      'client_id': clientId,
      'seller_id': sellerId,
      'total_amount': totalAmount,
      'total_surcharge': totalSurcharge,
      'outstanding_balance': outstandingBalance,
      'start_date': startDate,
      'due_date': dueDate,
      'status': status,
      'observations': observations,
      //'created_at'
    };
  }
}