class ProductModel {
  final int productId;
  final String name;
  final String code;
  final String description;
  final double unitPrice;
  final double? surcharge;
  final int minimumStock;
  final String unitMeasure;
  final int categoryID;
  final int availability;
  final int status;

  ProductModel({
    required this.productId,
    required this.name,
    required this.code,
    required this.description,
    required this.unitPrice,
    required this.surcharge,
    required this.minimumStock,
    required this.unitMeasure,
    required this.categoryID,
    required this.availability,
    required this.status,
  });

  // Convertir desde Map (resultado de SQLite) a ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['product_id'] ?? 0,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      unitPrice: (map['unit_price'] ?? 0).toDouble(),
      surcharge: (map['surcharge'] ?? 0).toDouble(),
      minimumStock: map['minimum_stock'] ?? 0,
      unitMeasure: map['unit_measure'] ?? '',
      categoryID: map['category_id'] ?? 0,
      availability: map['availability'] ?? 0,
      status: map['status'] ?? 0,
    );
  }
}
