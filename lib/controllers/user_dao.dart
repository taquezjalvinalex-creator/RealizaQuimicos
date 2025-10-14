import '../database/database.dart';

class UserDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar usuario
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user);
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await dbHelper.database;
    return await db.query('users');
  }

  // Buscar un usuario por email y password (login)
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Actualizar usuario
  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await dbHelper.database;
    return await db.update(
      'users',
      user,
      where: 'user_id = ?',
      whereArgs: [user['user_id']],
    );
  }

  // Eliminar usuario
  Future<int> deleteUser(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }
}
