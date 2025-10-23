import 'package:proyecto_uno/controllers/visit_dao.dart';
import 'package:proyecto_uno/models/client_model.dart';
import '../database/database.dart';
import '../models/client_detail_model.dart';
import '../models/payment_model.dart';
import '../models/visit_model.dart';
import 'package:intl/intl.dart'; //Formato de fecha

class ClientDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar cliente
  Future<int> insertClient(ClientModel client) async {
    final String dateToday = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final db = await dbHelper.database;
    int clientId = await db.insert('clients', {
      'route_id': client.routeId,
      'first_name': client.firstName.toUpperCase(),
      'last_name': client.lastName?.toUpperCase(),
      'document_type': client.documentType,
      'document_number': client.documentNumber,
      'address': client.address,
      'phone': client.phone,
      'home_photo_url': 'client.homePhoto',
      'reference_description': client.referenceDescription,
      'status': client.status,
      'created_at': dateToday,
      'latitude': 0.0,
      'longitude': 0.0,
    });

    VisitDao().registrarVisita(
      clientId: clientId,
      status: 2,
      observations: 'Se registró como cliente nuevo',
    );

    return clientId;
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
    final db = await dbHelper.database;
    // Consulta personalizada para obtener el resumen de rutas
    final result = await db.rawQuery('''
      WITH 
      creditos AS (
          SELECT 
             cr.client_id,
             SUM(cr.outstanding_balance) AS total_creditos
          FROM credits cr
          WHERE cr.status = 1
          GROUP BY cr.client_id
      ),
      pagos_hoy AS (
        SELECT c.client_id,
        SUM(p.amount_paid) AS pagos_credito_hoy
        FROM payments p
        JOIN credits c ON p.credit_id = c.credit_id
        WHERE p.credit_id IS NOT NULL
        AND date(p.payment_date) = date('now','localtime')
        GROUP BY c.client_id
      ),
      visitas_hoy AS (
         SELECT cv.client_id, cv.status FROM client_visits cv
         WHERE date(cv.visit_date) = date('now','localtime')
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
          COALESCE(vh.status, 0) AS status,
          COALESCE(crs.total_creditos, 0) AS credits,
          COALESCE(ph.pagos_credito_hoy, 0) AS payments,
          strftime('%d/%m/%Y', MAX(cv.visit_date)) AS last_visit
      FROM clients cl
      LEFT JOIN client_visits cv ON cv.client_id = cl.client_id
      LEFT JOIN visitas_hoy vh ON vh.client_id=cl.client_id
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
          WHERE cr.status = 1
          GROUP BY cr.client_id
      ),
      pagos_hoy AS (
        SELECT c.client_id,
        SUM(p.amount_paid) AS pagos_credito_hoy
        FROM payments p
        JOIN credits c ON p.credit_id = c.credit_id
        WHERE p.credit_id IS NOT NULL
        AND date(p.payment_date) = date('now','localtime')
        GROUP BY c.client_id
      ),
      visitas_hoy AS (
         SELECT cv.client_id, cv.status FROM client_visits cv
         WHERE date(cv.visit_date) = date('now','localtime')
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
          COALESCE(vh.status, 0) AS status,
          COALESCE(crs.total_creditos, 0) AS credits,
          COALESCE(ph.pagos_credito_hoy, 0) AS payments,
          strftime('%d/%m/%Y', MAX(cv.visit_date)) AS last_visit
      FROM clients cl
      LEFT JOIN client_visits cv ON cv.client_id = cl.client_id
      LEFT JOIN visitas_hoy vh ON vh.client_id=cl.client_id
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
