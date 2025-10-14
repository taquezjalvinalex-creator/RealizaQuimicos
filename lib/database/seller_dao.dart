import 'package:proyecto_uno/utils/session_manager.dart';
import 'database.dart';


class SellerDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar vendedor
  Future<int> insertSeller(Map<String, dynamic> seller) async {
    final db = await dbHelper.database;
    return await db.insert('sellers', seller);
  }

  // Obtener todas los vendedors
  Future<List<Map<String, dynamic>>> getSellers() async {
    final db = await dbHelper.database;
    return await db.query('sellers');
  }

  // Buscar un vendedor por id
  Future<Map<String, dynamic>?> findSeller(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'sellers',
      where: 'seller_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Buscar un vendedor por id de usuario
  Future<int> findSellerByUser() async {
    final userId = await SessionManager.getUserId();
    final db = await dbHelper.database;
    final result = await db.query(
      'sellers',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    final sellerData = result.first;
    return sellerData['seller_id'] as int;
  }

  // Actualizar vendedor
  Future<int> updateSeller(Map<String, dynamic> seller) async {
    final db = await dbHelper.database;
    return await db.update(
      'sellers',
      seller,
      where: 'seller_id = ?',
      whereArgs: [seller['seller_id']],
    );
  }

  // Eliminar vendedor
  Future<int> deleteSeller(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'sellers',
      where: 'seller_id = ?',
      whereArgs: [id],
    );
  }
}
