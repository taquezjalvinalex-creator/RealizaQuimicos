class ItemModel {
  final int? itemId;
  final int? saleId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double surcharge;
  final double totalPrice;
  final double totalSurcharge;


  ItemModel({
    required this.itemId,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.surcharge,
    required this.totalPrice,
    required this.totalSurcharge,

  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemId: map['sale_item_id'] ?? 0,
      saleId: map['sale_id'] ?? 0,
      productId: map['product_id'] ?? 0,
      quantity: map['quiantity'] ?? 0,
      unitPrice: (map['unit_price'] ?? 0).toDouble(),
      surcharge: (map['surcharge'] ?? 0).toDouble(),
      totalPrice: (map['total_price'] ?? 0).toDouble(),
      totalSurcharge: (map['total_surcharge'] ?? 0).toDouble(),

    );
  }
}
