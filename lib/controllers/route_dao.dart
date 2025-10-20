import '../utils/session_manager.dart';
import '../database/database.dart';
import 'package:proyecto_uno/models/route_model.dart';

class RouteDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar ruta
  Future<int> insertRoute(Map<String, dynamic> route) async {
    final db = await dbHelper.database;
    return await db.insert('routes', route);
  }

  // Obtener todas las rutas
  Future<List<Map<String, dynamic>>> getRoutes() async {
    final db = await dbHelper.database;
    return await db.query('routes');
  }

  // Buscar un ruta por id
  Future<Map<String, dynamic>?> findRoute(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'routes',
      where: 'route_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Buscar un ruta por id
  Future<String> getRouteName(int routeId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'routes',
      where: 'route_id = ?',
      whereArgs: [routeId],
    );
    String routeName = result.isEmpty ? '' : result.first['name'] as String;
    return routeName;
  }

  // Buscar  ruta por vendedor /aun no implementado
  Future<Map<String, dynamic>?> findRouteBySeller(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'routes',
      where: 'route_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Actualizar ruta
  Future<int> updateRoute(Map<String, dynamic> route) async {
    final db = await dbHelper.database;
    return await db.update(
      'routes',
      route,
      where: 'route_id = ?',
      whereArgs: [route['route_id']],
    );
  }

  // Eliminar ruta
  Future<int> deleteRoute(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'routes',
      where: 'route_id = ?',
      whereArgs: [id],
    );
  }

  // Consulta personalizada para obtener el resumen de rutas por vendedor
  Future<List<RouteModel>> getRouteyBySeller() async {
    final userId = await SessionManager.getUserId();
    final db = await dbHelper.database;
    // Consulta personalizada para obtener el resumen de rutas
    final result = await db.rawQuery('''
      WITH       
       sales_ AS (
          SELECT c.route_id, sa.seller_id, SUM(sa.total_price) AS ventas_contado_hoy
          FROM sales sa
          JOIN clients c ON c.client_id = sa.client_id
          WHERE sa.payment_type = 1
            AND date(sa.sale_date) = date('now','localtime')
          GROUP BY c.route_id, sa.seller_id
        ),
        
        payments_ AS (
          SELECT c.route_id, cr.seller_id, SUM(p.amount_paid) AS pagos_credito_hoy
          FROM payments p
          JOIN credits cr ON cr.credit_id = p.credit_id
          JOIN clients c ON c.client_id = cr.client_id
          WHERE date(p.payment_date) = date('now','localtime')
          GROUP BY c.route_id, cr.seller_id
        ),
        
        clients_ AS (
          SELECT route_id, 
          COUNT(client_id) AS numero_clientes 
          FROM clients 
          GROUP BY route_id
        )
        
        SELECT
          r.route_id,
          r.name AS route_name,
          us.user_id,
          rl.number_visits,
          s.seller_id,
          COALESCE(vc.ventas_contado_hoy, 0) AS sales,
          COALESCE(pc.pagos_credito_hoy, 0) AS payments,
          COALESCE(nc.numero_clientes, 0) AS clients
          
        FROM routes r
        JOIN seller_routes sr ON sr.route_id = r.route_id
        JOIN sellers s ON s.seller_id = sr.seller_id
        LEFT JOIN route_log rl ON rl.route_id=r.route_id AND date(rl.start_date) = date('now','localtime') 
        LEFT JOIN sales_ vc ON vc.route_id = r.route_id AND vc.seller_id = s.seller_id
        LEFT JOIN payments_ pc  ON pc.route_id = r.route_id AND pc.seller_id = s.seller_id
        LEFT JOIN clients_ nc ON nc.route_id =  r.route_id
        LEFT JOIN users us ON us.user_id=s.user_id
        WHERE us.user_id = ?
        ORDER BY r.route_day;
    ''', [userId]); //
    print(result);
    return result.map((row) => RouteModel.fromMap(row)).toList();
  }

}
