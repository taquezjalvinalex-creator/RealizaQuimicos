import 'package:proyecto_uno/models/sale_model.dart';

import '../database/database.dart';
import '../models/credit_model.dart';
//import 'package:intl/intl.dart'; //Formato de fecha

class CreditDao {
  final dbHelper = DBRealezaQuimicos.instance;

  Future<List<CreditModel>> getAllCredits() async {
    final db = await dbHelper.database;
    final result = await db.query(
      'credits',
      where: 'status = ?',
      whereArgs: [1],
    );
    return result.map((row) => CreditModel.fromMap(row)).toList();
  }


  Future<void> applySurchargesIfNeeded() async {

    final db = await dbHelper.database;
    // Fecha actual en formato compatible con SQLite
    //final String dateToday = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final today = DateTime.now();
    //final today = DateTime.now().toIso8601String();//DateFormat('yyyy-MM-dd').format(today);

    // 1️⃣ Obtener todos los créditos activos
   /* final List<CreditModel> activeCredits = await db.query(
      'credits',
      where: 'status = ?',
      whereArgs: [1],
    );*/
    final List<CreditModel> activeCredits = await getAllCredits();

    for (var credit in activeCredits) {
      // ✅ Accede a las propiedades del modelo directamente.
      final DateTime startDate = DateTime.parse(credit.startDate);
      final int daysPassed = today.difference(startDate).inDays;

      // 3️⃣ Si han pasado más de 8 días desde la fecha de inicio del crédito
      if (daysPassed > 8) {

        // ✅ Obtén los valores directamente del objeto 'credit'.
        final double outstandingBalance = credit.outstandingBalance;
        final double totalSurcharge = credit.totalSurcharge; // Asumo que este es el monto del recargo a aplicar.
        final int creditId = credit.creditId;

        // Calcula el nuevo saldo pendiente sumando el recargo.
        final double newBalance = outstandingBalance + totalSurcharge;

        print('Aplicando recargo al crédito ID: $creditId. Días pasados: $daysPassed. Nuevo saldo: $newBalance');

        // 4️⃣ Actualizar el registro en la base de datos
        await db.update(
          'credits', // Nombre de la tabla
          {
            'outstanding_balance': newBalance,
            'status': 2, // Cambiar el estado a 'vencido con recargo'
          },
          where: 'credit_id = ?',
          whereArgs: [creditId],
        );
      }
    }
  }

  // Guardar un nuevo crédito
  Future<void> insertCredit(SaleModel sale) async {
    final db = await dbHelper.database;

    // 1. Insertar el crédito en la tabla credits
    await db.insert(
      'credits', // Nombre de la tabla
      {
        'sale_id': sale.saleId,
        'client_id': sale.clientId,
        'seller_id': sale.sellerId,
        'total_amount': sale.totalPrice,
        'total_surcharge': sale.totalSurcharge,
        'outstanding_balance': sale.totalPrice,
        'start_date': sale.saleDate,
        'due_date': null,
        'status': 1, // Estado inicial del crédito
        'observations': '',
      },
    );
  }
}
