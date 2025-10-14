import 'package:proyecto_uno/models/order_model.dart';
import '../database/database.dart';

class OrderDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar pedido
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await dbHelper.database;
    return await db.insert('orders', order);
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
       ord.total_price
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
