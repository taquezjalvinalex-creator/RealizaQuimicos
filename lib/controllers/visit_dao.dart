import 'package:proyecto_uno/database/database.dart';
import '../utils/session_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart'; //Formato de fecha

class VisitDao {
  final dbHelper = DBRealezaQuimicos.instance;

  /// Registra una visita de cliente y aplica las validaciones del flujo
  Future<int> registrarVisita({
    //required int routeId,
    required int clientId,
    required int status,
    String? observations,
  }) async {
    final db = await dbHelper.database;
    int todaysVisitId = 0;

    await db.transaction((txn) async {
      final String dateToday = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Obtener el vendedor asociado a la ruta
      final userId = await SessionManager.getUserId();
      final List<Map<String, dynamic>> sellerLogged = await txn.query(
        'sellers',
        where: 'user_id = ? ',
        whereArgs: [userId],
      );
      int sellerId = sellerLogged.first['seller_id'] as int;

      // Obtener la ruta asociada al cliente
      final List<Map<String, dynamic>> routeClient = await txn.query(
        'clients',
        where: 'client_id = ? ',
        whereArgs: [clientId],
      );
      int routeId = routeClient.first['route_id'] as int;

      // 1️⃣ Verificar si hay un route_log activo (status = 1)
      final List<Map<String, dynamic>> activeLogs = await txn.query(
        'route_log',
        where: 'route_id = ? AND status = 1',
        whereArgs: [routeId],
      );

      int logId; // Id del log
      if (activeLogs.isEmpty) {
        // Crear un nuevo log si no existe uno activo
        logId = await txn.insert('route_log', {
          'route_id': routeId,
          'number_visits': 0,
          'status': 1,
          'start_date': dateToday,
          'observations': 'Inicio automático de registro de visitas',
        });
      } else {
        logId = activeLogs.first['log_id'] as int;
      }

      // Verificar si hay un registro de visita de cliente en la misma fecha
      final List<Map<String, dynamic>> visitedClient = await txn.query(
        'client_visits',
        where: 'date(visit_date) =  date(?) AND client_id = ?',
        whereArgs: [dateToday, clientId],
      );

      int visitId; // obtener el id de visit_today
      if(visitedClient.isEmpty){
        // 2️⃣ Insertar registro en client_visits
        todaysVisitId = await txn.insert('client_visits', {
          'log_id': logId,
          'client_id': clientId,
          'seller_id': sellerId,
          'status': status,
          'observations': observations ?? '',
          'visit_date': dateToday,
        });

        // 3️⃣ Actualizar número de visitas del log
        await txn.rawUpdate('''
        UPDATE route_log
        SET number_visits = number_visits + 1
        WHERE log_id = ?
      ''', [logId]);

      } else {
        visitId = visitedClient.first['visit_id'] as int;
        todaysVisitId = visitId;
        // Actualizar registro de STATUS en client_visits
        await txn.rawUpdate('''
        UPDATE client_visits
        SET status = ?
        WHERE visit_id = ?
      ''', [status, visitId]);
      }

      // 4️⃣ Verificar si se han visitado todos los clientes de la ruta
      final totalClientes = Sqflite.firstIntValue(await txn.rawQuery(
        'SELECT COUNT(*) FROM clients WHERE status = 1 AND route_id = ?',
        [routeId],
      ));

      final totalVisitas = Sqflite.firstIntValue(await txn.rawQuery(
        'SELECT number_visits FROM route_log WHERE log_id = ?',
        [logId],
      ));

      if (totalClientes != null &&
          totalVisitas != null &&
          totalVisitas >= totalClientes) {
        // Marcar el log como finalizado
        await txn.update(
          'route_log',
          {
            'status': 0,
            'end_date': dateToday,
            'observations': 'Ruta finalizada con todos los clientes visitados.',
          },
          where: 'log_id = ?',
          whereArgs: [logId],
        );
      }
    });
    print('>>>>>ID DE LA VISITA >>>>>> $todaysVisitId');
    return todaysVisitId;
  }
}
