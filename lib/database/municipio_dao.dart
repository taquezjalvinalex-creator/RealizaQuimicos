import 'database.dart';

class MunicipioDao {
  final dbHelper = DBRealezaQuimicos.instance;

  // Insertar municipio
  Future<int> insertMunicipio(Map<String, dynamic> municipio) async {
    final db = await dbHelper.database;
    return await db.insert('municipios', municipio);
  }

  // Obtener todos los municipios
  Future<List<Map<String, dynamic>>> getMunicipios() async {
    final db = await dbHelper.database;
    return await db.query('municipios');
  }

  // Buscar un municipio por id
  Future<Map<String, dynamic>?> findMunicipio(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'municipios',
      where: 'municipio_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Actualizar municipio
  Future<int> updateMunicipio(Map<String, dynamic> municipio) async {
    final db = await dbHelper.database;
    return await db.update(
      'municipios',
      municipio,
      where: 'municipio_id = ?',
      whereArgs: [municipio['municipio_id']],
    );
  }

  // Eliminar municipio
  Future<int> deleteMunicipio(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'municipios',
      where: 'municipio_id = ?',
      whereArgs: [id],
    );
  }
}
