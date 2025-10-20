import '../database/database.dart';
import '../models/credit_model.dart';

class CreditsDao {
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
    final today = DateTime.now();
    //final todayDate = DateTime.parse(today);
    //final todayStr = DateTime.now().toIso8601String();//DateFormat('yyyy-MM-dd').format(today);

    // 1️⃣ Obtener todos los créditos activos
   /* final List<CreditModel> activeCredits = await db.query(
      'credits',
      where: 'status = ?',
      whereArgs: [1],
    );*/
    final List<CreditModel> activeCredits = await getAllCredits();

    for (var credit in activeCredits) {
      // ✅ Accede a las propiedades del modelo directamente.
      // Asegúrate de que tu CreditModel tenga una propiedad 'startDate' de tipo DateTime.
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
  Future<void> insertCredit(CreditModel credit) async {
    final db = await dbHelper.database;

    // 1. Crear la tabla de ventas con el nuevo crédito payment_type = 0
      //Pasar product_model y sale_model a la tabla de ventas
    /*
    int saleId = await saleDao.insertSale(
      productModel: productModel,
      saleModel: saleModel,
    );*/

    // 2. Insertar el crédito en la tabla credits


  }
}
