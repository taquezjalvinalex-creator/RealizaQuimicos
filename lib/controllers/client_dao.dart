import 'package:proyecto_uno/models/client_model.dart';
import '../database/database.dart';
import '../models/client_detail_model.dart';
import '../models/payment_model.dart';
import '../models/visit_model.dart';

class ClientDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar cliente
  Future<int> insertClient(Map<String, dynamic> client) async {
    final db = await dbHelper.database;
    return await db.insert('clients', client);
  }

  // Obtener todas los clientes
  Future<List<Map<String, dynamic>>> getClients() async {
    final db = await dbHelper.database;
    return await db.query('clients');
  }

  // Buscar un cliente por id
  Future<Map<String, dynamic>?> findClient(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'clients',
      where: 'client_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Actualizar cliente
  Future<int> updateClient(Map<String, dynamic> client) async {
    final db = await dbHelper.database;
    return await db.update(
      'clients',
      client,
      where: 'client_id = ?',
      whereArgs: [client['client_id']],
    );
  }

  // Eliminar cliente
  Future<int> deleteClient(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'clients',
      where: 'client_id = ?',
      whereArgs: [id],
    );
  }

  // Consulta el resumen de clientes por ruta
  Future<List<ClientModel>> getClientByRoute(int routeId) async {
    //final userId = await SessionManager.getUserId();
    final db = await dbHelper.database;
    // Consulta personalizada para obtener el resumen de rutas
    final result = await db.rawQuery('''
      WITH 
      creditos AS (
          SELECT 
             cr.client_id,
             SUM(cr.outstanding_balance) AS total_creditos
          FROM credits cr
          GROUP BY cr.client_id
      ),
      pagos_hoy AS (
          SELECT 
              sl.client_id,
              SUM(p.amount_paid) AS pagos_credito_hoy
          FROM payments p
          JOIN sales sl ON sl.sale_id = p.sale_id
          JOIN credits c ON p.credit_id = c.credit_id
          WHERE p.credit_id IS NOT NULL
            AND date(p.payment_date) = date('now','localtime')
          GROUP BY sl.client_id
      )
      SELECT 
          cl.client_id,
          cl.route_id,
          cl.first_name,
          cl.last_name,
          cl.document_type,
          cl.document_number,
          cl.address,
          cl.phone,
          cl.home_photo_url,
          cl.reference_description,
          cv.status,
          COALESCE(crs.total_creditos, 0) AS credits,
          COALESCE(ph.pagos_credito_hoy, 0) AS payments,
          strftime('%d/%m/%Y', MAX(cv.visit_date)) AS last_visit
      FROM clients cl
      LEFT JOIN client_visits cv ON cv.client_id = cl.client_id
      LEFT JOIN creditos crs ON crs.client_id=cl.client_id
      LEFT JOIN pagos_hoy ph ON cl.client_id = ph.client_id
      WHERE cl.route_id = ?
      GROUP BY cl.client_id;
    ''', [routeId]);
    return result.map((row) => ClientModel.fromMap(row)).toList();
  }

  // Consulta resumen de todos los clientes
  Future<List<ClientModel>> getAllClients() async {
    //final userId = await SessionManager.getUserId();
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      WITH 
      creditos AS (
          SELECT 
             cr.client_id,
             SUM(cr.outstanding_balance) AS total_creditos
          FROM credits cr
          GROUP BY cr.client_id
      ),
      pagos_hoy AS (
          SELECT 
              sl.client_id,
              SUM(p.amount_paid) AS pagos_credito_hoy
          FROM payments p
          JOIN sales sl ON sl.sale_id = p.sale_id
          JOIN credits c ON p.credit_id = c.credit_id
          WHERE p.credit_id IS NOT NULL
            AND date(p.payment_date) = date('now','localtime')
          GROUP BY sl.client_id
      )
      SELECT 
          cl.client_id,
          cl.route_id,
          cl.first_name,
          cl.last_name,
          cl.document_type,
          cl.document_number,
          cl.address,
          cl.phone,
          cl.home_photo_url,
          cl.reference_description,
          cv.status,
          COALESCE(crs.total_creditos, 0) AS credits,
          COALESCE(ph.pagos_credito_hoy, 0) AS payments,
          strftime('%d/%m/%Y', MAX(cv.visit_date)) AS last_visit
      FROM clients cl
      LEFT JOIN client_visits cv ON cv.client_id = cl.client_id
      LEFT JOIN creditos crs ON crs.client_id=cl.client_id
      LEFT JOIN pagos_hoy ph ON cl.client_id = ph.client_id
      GROUP BY cl.client_id;
    ''');
    return result.map((row) => ClientModel.fromMap(row)).toList();
  }

  Future<ClientDetailModel> getClientDetail(int clientId) async {
    final db = await dbHelper.database;

    // 1️⃣ Consultar datos del cliente
    final clientResult = await db.query(
      'clients',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );

    if (clientResult.isEmpty) {
      throw Exception('Cliente no encontrado');
    }

    var client = ClientDetailModel.fromMap(clientResult.first);

    // 2️⃣ Consultar los últimos 3 pagos
    final paymentResults = await db.rawQuery('''
    SELECT * FROM payments py
    JOIN credits cr ON cr.credit_id = py.credit_id  
    WHERE cr.client_id = ? 
    ORDER BY payment_date DESC 
    LIMIT 3
  ''', [clientId]);
    final payments =
    paymentResults.map((e) => PaymentModel.fromMap(e)).toList();

    // 3️⃣ Consultar las últimas 3 visitas
    final visitResults = await db.rawQuery('''
    SELECT * FROM client_visits 
    WHERE client_id = ? 
    ORDER BY visit_date DESC 
    LIMIT 3
  ''', [clientId]);
    final visits = visitResults.map((e) => VisitModel.fromMap(e)).toList();

    // 4️⃣ Combinar los datos
    return client.copyWith(payments: payments, visits: visits);
  }
}
