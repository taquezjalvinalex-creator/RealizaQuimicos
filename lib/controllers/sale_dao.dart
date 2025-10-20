import 'package:proyecto_uno/controllers/visit_dao.dart';
import 'package:proyecto_uno/models/product_model.dart';
import '../database/database.dart';
import '../models/item_model.dart';
import '../models/sale_model.dart';
import 'package:intl/intl.dart';

import '../utils/session_manager.dart'; //Formato de fecha

class SaleDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Obtener todos las ventas
  Future<List<ProductModel>> getSales() async {
    final db = await dbHelper.database;
    final result = await db.query('sales');
    return result.map((row) => ProductModel.fromMap(row)).toList(); //Modelo de ventas
  }

  Future<SaleModel> insertSale({
    required int clientId,
    required int paymentType,
    required String status,
    required double totalPrice,
    required double? totalSurcharge,
    required int? orderId,
    required List<ItemModel> items,
    //required SaleModel sale,
  }) async {  // Lista product_model, sale_model

    final db = await dbHelper.database;
    final String dateToday = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // 1. REGISTRAR LA VISITA DEL CLIENTE
    final int visitId = await VisitDao().registrarVisita(
      clientId: clientId,
      status: 3,
      observations: 'Se registró una venta: $status',
    );

    // Obtener el vendedor
    final userId = await SessionManager.getUserId();
    final List<Map<String, dynamic>> sellerLogged = await db.query(
      'sellers',
      where: 'user_id = ? ',
      whereArgs: [userId],
    );
    int sellerId = sellerLogged.first['seller_id'] as int;

    // 2. REGISTRAR LA VENTA
    int saleId = await db.insert('sales', {
      'visit_id': visitId,
      'order_id': null,
      'client_id': clientId,
      'seller_id': sellerId,
      'sale_date': dateToday,
      'payment_type': paymentType,
      'total_price': totalPrice,
      'total_surcharge': 0, //Pendiente
      'status': status,
      'observations': '',
    });

    // 3.Agregar productos a la venta
    for (var item in items) {
      // Insertar el detalle de la venta
      await db.insert('sale_items', {
        'sale_id': saleId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'unit_price': item.unitPrice,
        'surcharge': item.surcharge,
        'total_price': item.totalPrice,
        'total_surcharge': item.totalSurcharge,
      });
    }
    //Devolver el id de la venta
    return SaleModel(
        saleId: saleId,
        visitId: visitId,
        orderId: orderId,
        clientId: clientId,
        sellerId: sellerId,
        saleDate: dateToday,
        paymentType: paymentType,
        totalPrice: totalPrice,
        totalSurcharge: totalSurcharge ?? 0,
        status: status,
        observations: ''
    );
  }


}