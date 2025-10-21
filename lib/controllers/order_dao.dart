import 'package:proyecto_uno/controllers/visit_dao.dart';
import 'package:proyecto_uno/models/order_model.dart';
import '../database/database.dart';
import '../models/item_model.dart';
import '../utils/session_manager.dart';
import 'package:intl/intl.dart';

class OrderDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar pedido
  Future<int> insertOrder({
    required int clientId,
    required int totalQuantity,
    required double totalPrice,
    required double? totalSurcharge,
    required List<ItemModel> items,
  }) async {

    final db = await dbHelper.database;
    final String dateToday = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // 1. REGISTRAR LA VISITA DEL CLIENTE
    await VisitDao().registrarVisita(
      clientId: clientId,
      status: 3,
      observations: 'Se registró un pedido',
    );

    // Obtener el vendedor
    final userId = await SessionManager.getUserId();
    final List<Map<String, dynamic>> sellerLogged = await db.query(
      'sellers',
      where: 'user_id = ? ',
      whereArgs: [userId],
    );
    int sellerId = sellerLogged.first['seller_id'] as int;

    // 2. REGISTRAR EL PEDIDO
    int orderId = await db.insert('orders', {
      'client_id': clientId,
      'seller_id': sellerId,
      'order_date': dateToday,
      'total_price': totalPrice,
      'total_surcharge': totalSurcharge,
      'status': 'PENDIENTE',
      'total_quantity': totalQuantity,
      'observations': '',
    });

    // 3.Agregar productos a la venta
    for (var item in items) {
      // Insertar el detalle de la venta
      await db.insert('order_items', {
        'order_id': orderId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'status': 'PENDIENTE',
        'unit_price': item.unitPrice,
        'surcharge': item.surcharge,
        'total_price': item.totalPrice,
        'total_surcharge': item.totalSurcharge,
      });
    }
    return orderId;
  }

  // Buscar un pedido por id
  Future<Map<String, dynamic>?> findClient(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'orders',
      where: 'order_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Actualizar pedido
  Future<int> updateClient(Map<String, dynamic> order) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      order,
      where: 'order_id = ?',
      whereArgs: [order['order_id']],
    );
  }

  // Eliminar pedido
  Future<int> deleteClient(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'orders',
      where: 'order_id = ?',
      whereArgs: [id],
    );
  }

  // Consulta el resumen de pedidos por ruta
  Future<List<OrderModel>> getOrderByRoute(int routeId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT ord.order_id,
       ord.client_id,
       cl.first_name AS client_name,
       cl.last_name AS client_last_name,
       ord.seller_id,
       sl.first_name AS seller_name,
       sl.last_name AS seller_last_name,
       ord.status,
       strftime('%d/%m/%Y', ord.order_date) AS order_date,
       ord.total_quantity,
       ord.total_price,
       ord.total_surcharge,
       ord.observations
      FROM orders ord
      JOIN clients cl ON cl.client_id = ord.client_id
      JOIN sellers sl ON sl.seller_id = ord.seller_id
      WHERE cl.route_id = ?
      GROUP BY ord.order_id;
    ''', [routeId]);
    return result.map((row) => OrderModel.fromMap(row)).toList();
  }

  // Consulta resumen de todos los pedidos
  Future<List<OrderModel>> getAllOrders() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT ord.order_id,
       ord.client_id,
       cl.first_name AS client_name,
       cl.last_name AS client_last_name,
       ord.seller_id,
       sl.first_name AS seller_name,
       sl.last_name AS seller_last_name,
       ord.status,
       strftime('%d/%m/%Y', ord.order_date) AS order_date,
       ord.total_quantity,
       ord.total_price
      FROM orders ord
      JOIN clients cl ON cl.client_id = ord.client_id
      JOIN sellers sl ON sl.seller_id = ord.seller_id
      GROUP BY ord.order_id;
    ''');
    return result.map((row) => OrderModel.fromMap(row)).toList();
  }
}
