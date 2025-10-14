import 'package:proyecto_uno/models/product_model.dart';
import '../database/database.dart';

class ProductDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Obtener todos los productos
  Future<List<ProductModel>> getProducts() async {
    final db = await dbHelper.database;
    final result = await db.query('products');
    return result.map((row) => ProductModel.fromMap(row)).toList();
  }

}