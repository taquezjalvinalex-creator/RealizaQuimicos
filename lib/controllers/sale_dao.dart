import 'package:proyecto_uno/models/product_model.dart';
import '../database/database.dart';

class SaleDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Obtener todos las ventas
  Future<List<ProductModel>> getSales() async {
    final db = await dbHelper.database;
    final result = await db.query('sales');
    return result.map((row) => ProductModel.fromMap(row)).toList(); //Modelo de ventas
  }

  Future<int> insertSale() async {  // Lista product_model, sale_model

    final db = await dbHelper.database;
    final result = await db.query('sales');

    // Agregar productos

    // Insertar venta

    //Devolver el id de la venta

    return 1;
  }


}