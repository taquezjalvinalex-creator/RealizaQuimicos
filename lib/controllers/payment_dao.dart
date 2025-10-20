import 'package:proyecto_uno/database/database.dart';
import '../../models/payment_model.dart';
import '../../controllers/visit_dao.dart';
import '../utils/session_manager.dart';

// Clase auxiliar para manejar la información del crédito de forma clara
class _CreditInfo {
  final int creditId;
  double outstandingBalance;

  _CreditInfo({
    required this.creditId,
    required this.outstandingBalance
  });
}



// Clase para manejar las operaciones de pago
class PaymentDao {
  final dbHelper = DBRealezaQuimicos.instance;

  Future<void> insertPayment({
    required PaymentModel payment,
    required int clientId,
    required int routeId
  }) async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      // 1. OBTENER VARIABLES INICIALES
      double amountToApply = payment.amount;

      // Obtener el vendedor logeado
      final userId = await SessionManager.getUserId();
      final List<Map<String, dynamic>> sellerLogged = await txn.query(
        'sellers',
        where: 'user_id = ? ',
        whereArgs: [userId],
      );
      int sellerId = sellerLogged.first['seller_id'] as int;

      // 2. OBTENER LA LISTA DE CRÉDITOS PENDIENTES DEL CLIENTE
      // Se obtienen los créditos con saldo pendiente (status != 0) y se ordenan del más antiguo al más reciente.
      final List<Map<String, dynamic>> creditsFromDb = await txn.query(
        'credits', // Nombre de tu tabla de créditos
        columns: ['credit_id', 'outstanding_balance'],
        where: 'client_id = ? AND status != ?',
        whereArgs: [clientId, 0],
        orderBy: 'start_date ASC',
      );

      // Si no hay créditos pendientes, no hacemos nada con los créditos.
      if (creditsFromDb.isEmpty) {
        print(
            "Advertencia: El cliente no tiene créditos pendientes para aplicar el abono.");
        // Aquí podrías decidir si registrar el pago como un "saldo a favor" o detener la operación.
        // Por ahora, continuaremos para registrar el pago, aunque no se aplique a ningún crédito.
      }

      // 3. CONVERTIR LA LISTA DE MAPAS A UNA LISTA DE OBJETOS _CreditInfo
      final List<_CreditInfo> creditList = creditsFromDb.map((creditMap) {
        return _CreditInfo(
          creditId: creditMap['credit_id'] ?? 0,
          outstandingBalance: (creditMap['outstanding_balance'] ?? 0).toDouble(),
        );
      }).toList();


      // 4. ITERAR SOBRE LA LISTA DE CRÉDITOS Y APLICAR EL ABONO
      for (var credit in creditList) {
        // Si ya no queda monto por aplicar, detenemos el bucle.
        if (amountToApply <= 0) {
          break;
        }

        // Comprobar si el monto a aplicar es mayor o igual al saldo del crédito actual
        if (amountToApply >= credit.outstandingBalance) {
          // CASO 1: El abono cubre o supera el saldo del crédito.

          // Se resta el saldo del crédito del monto a aplicar.
          amountToApply -= credit.outstandingBalance;

          // Se actualiza el crédito en la base de datos: se salda por completo.
          await txn.update(
            'credits',
            {
              'outstanding_balance': 0,
              'status': 0, // Marcar como saldado
            },
            where: 'credit_id = ?',
            whereArgs: [credit.creditId],
          );
          // Se registra el pago en la base de datos.
          print("Abono aplicado con defla ${payment.paymentDate}");
          await txn.insert('payments',{

            'credit_id': credit.creditId,
            'seller_id': sellerId,
            'payment_method_id': payment.methodId,
            'amount_paid': credit.outstandingBalance,
            'remaining_balance': 0,
            'payment_receipt': payment.receipt,
            'payment_date': payment.paymentDate,
            'observations': payment.observation,
          });

          print("Crédito ID ${credit
              .creditId} saldado. Monto restante por aplicar: \$${amountToApply
              .toStringAsFixed(2)}");
        } else {
          // CASO 2: El abono es menor que el saldo del crédito.

          // El nuevo saldo pendiente será el saldo actual menos el monto aplicado.
          double newBalance = credit.outstandingBalance - amountToApply;

          // Se actualiza el crédito en la base de datos con el nuevo saldo.
          await txn.update(
            'credits',
            {
              'outstanding_balance': newBalance,
              // El estado no cambia porque aún tiene saldo.
            },
            where: 'credit_id = ?',
            whereArgs: [credit.creditId],
          );

          // Se registra el pago en la base de datos.
          print("Abono aplicado con defla ${payment.paymentDate}");
          await txn.insert('payments',{

            'credit_id': credit.creditId,
            'seller_id': sellerId,
            'payment_method_id': payment.methodId,
            'amount_paid': amountToApply,
            'remaining_balance': newBalance,
            'payment_receipt': payment.receipt,
            'payment_date': payment.paymentDate,
            'observations': payment.observation,
          });

          // El monto a aplicar se consume por completo.
          amountToApply = 0;

          print("Abono aplicado al crédito ID ${credit
              .creditId}. Nuevo saldo: \$${newBalance.toStringAsFixed(2)}");

          // Salimos del bucle ya que no queda más monto por aplicar.
          break;
        }
      }

      // 5. REGISTRAR LA VISITA DEL CLIENTE|
      VisitDao().registrarVisita(
        clientId: clientId,
        status: 3,
        observations: 'Se registró un abono de \$${payment.amount}',
      );
      print("Registro de pago completado por un monto de \$${payment.amount}.");

      // Si después de aplicar a todos los créditos aún sobra dinero (amountToApply > 0),
      // esto se considera un "saldo a favor". La lógica para manejarlo (guardarlo en otra tabla, etc.)
      // podría ir aquí si es necesario.
      if (amountToApply > 0) {
        print("Advertencia: Se registró un saldo a favor de \$${amountToApply
            .toStringAsFixed(2)} para el cliente ID: $clientId.");
      }
    });
  }
}