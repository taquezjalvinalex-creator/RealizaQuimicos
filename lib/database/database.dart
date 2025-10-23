import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBRealezaQuimicos {
  static final DBRealezaQuimicos instance = DBRealezaQuimicos._init();
  static Database? _database;

  DBRealezaQuimicos._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {

      // TABLA USUARIOS
    await db.execute('''
      CREATE TABLE users (
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          role TEXT NOT NULL CHECK(role IN ('ADMIN','VENDEDOR','CLIENTE')),
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime'))
      )
      ''');

      // TABLA MUNICIPIOS
    await db.execute('''
      CREATE TABLE municipios (
          municipio_id INTEGER PRIMARY KEY,
          name TEXT NOT NULL UNIQUE,
          departamento TEXT NOT NULL,
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime'))
      )
      ''');

      // TABLA RUTAS
    await db.execute('''
      CREATE TABLE routes (
          route_id INTEGER PRIMARY KEY AUTOINCREMENT,
          municipio_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          route_day INTEGER DEFAULT '0',
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime')),
          FOREIGN KEY (municipio_id) REFERENCES municipios(municipio_id),
          UNIQUE (name, municipio_id)
      )
      ''');

      // TABLA VENDEDORES
    await db.execute('''
      CREATE TABLE sellers (
          seller_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL UNIQUE,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          phone TEXT NOT NULL,
          document_number TEXT UNIQUE NOT NULL,
          hire_date TEXT NOT NULL, -- formato recomendado: YYYY-MM-DD
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO 3=SUSPENDIDO
          address TEXT,
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime')),
          FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
      ''');

      // TABLA CLIENTES
    await db.execute('''
      CREATE TABLE clients (
          client_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER UNIQUE,
          route_id INTEGER NOT NULL,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          document_type TEXT CHECK(document_type IN ('CC','TI','CE','NIT')),
          document_number TEXT NULL,
          phone TEXT,
          address TEXT NOT NULL,
          latitude REAL,
          longitude REAL,
          home_photo_url TEXT NULL,
          reference_description TEXT,
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime')),
          FOREIGN KEY (user_id) REFERENCES users(user_id),
          FOREIGN KEY (route_id) REFERENCES routes(route_id)
      
      )
      ''');

      // TABLA VENDEDORES RUTAS
    await db.execute('''
      CREATE TABLE seller_routes (
          seller_id INTEGER NOT NULL,
          route_id INTEGER NOT NULL,
          assignment_date TEXT NOT NULL, -- formato recomendado: YYYY-MM-DD
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          observations TEXT,
          PRIMARY KEY (seller_id, route_id),
          FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
          FOREIGN KEY (route_id) REFERENCES routes(route_id)
      )
      ''');

      // TABLA CATEGORIAS
    await db.execute('''
      CREATE TABLE categories (
          category_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          description TEXT,
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime'))
      )
      ''');

      //TABLA PRODUCTOS
    await db.execute('''
      CREATE TABLE products (
          product_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          code TEXT NOT NULL UNIQUE,
          description TEXT,
          unit_price REAL NOT NULL,
          surcharge REAL,
          minimum_stock INTEGER NOT NULL,
          unit_measure TEXT NOT NULL,
          category_id INTEGER NOT NULL,
          availability INTEGER DEFAULT '1', -- 1='DISPONIBLE',2='NO_DISPONIBLE')) DEFAULT 'DISPONIBLE',
          status INTEGER DEFAULT '1', -- ESTADOS 0=INACTIVO 1=ACTIVO
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime')),
          FOREIGN KEY (category_id) REFERENCES categories(category_id)
      )
      ''');

      //TABLA PEDIDOS
    await db.execute('''
      CREATE TABLE orders (
          order_id INTEGER PRIMARY KEY AUTOINCREMENT,
          client_id INTEGER NOT NULL,
          seller_id INTEGER NOT NULL,
          order_date TEXT DEFAULT (datetime('now','localtime')),
          status TEXT CHECK(status IN ('PENDIENTE','ENTREGA_PARCIAL','ENTREGADO','CANCELADO')) DEFAULT 'PENDIENTE',
          total_quantity INTEGER NOT NULL,
          total_price REAL NOT NULL,
          total_surcharge REAL,
          observations TEXT,
          FOREIGN KEY (client_id) REFERENCES clients(client_id),
          FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
      )
      ''');

      //TABLA DETALLE PEDIDOS
    await db.execute('''
      CREATE TABLE order_items (
          order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          status TEXT CHECK(status IN ('PENDIENTE','CANCELADO','ENTREGA_PARCIAL','ENTREGADO')) DEFAULT 'PENDIENTE',
          unit_price REAL NOT NULL,
          surcharge REAL,
          total_price REAL NOT NULL,
          total_surcharge REAL,
          FOREIGN KEY (order_id) REFERENCES orders(order_id),
          FOREIGN KEY (product_id) REFERENCES products(product_id)
      )
      ''');

      //TABLA METODOS DE PAGO
    await db.execute('''
      CREATE TABLE payment_methods (
          payment_method_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          qr TEXT,
          created_at TEXT DEFAULT (datetime('now','localtime')),
          updated_at TEXT DEFAULT (datetime('now','localtime'))
      )
      ''');

      //TABLA VENTAS
    await db.execute('''
      CREATE TABLE sales (
          sale_id INTEGER PRIMARY KEY AUTOINCREMENT,
          visit_id INTEGER,
          order_id INTEGER,
          client_id INTEGER NOT NULL,
          seller_id INTEGER NOT NULL,
          sale_date TEXT DEFAULT (datetime('now','localtime')),
          payment_type INTEGER DEFAULT '1', -- 1=CONTADO 0=CREDITO,
          total_price NUMERIC NOT NULL,
          total_surcharge NUMERIC NOT NULL,
          status TEXT DEFAULT 'SIN_CONFIRMAR' 
                 CHECK (status IN ('PAGADO', 'PENDIENTE_PAGO', 'CANCELADO', 'SIN_CONFIRMAR')),
          observations TEXT,
          FOREIGN KEY (visit_id) REFERENCES client_visits(visit_id),
          FOREIGN KEY (order_id) REFERENCES orders(order_id),
          FOREIGN KEY (client_id) REFERENCES clients(client_id),
          FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
      )
      ''');

      //TABLA DETALLE VENTAS
    await db.execute('''
      CREATE TABLE sale_items (
          sale_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          unit_price NUMERIC NOT NULL,
          surcharge NUMERIC DEFAULT 0,
          total_price NUMERIC NOT NULL,
          total_surcharge NUMERIC NOT NULL,
          FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
          FOREIGN KEY (product_id) REFERENCES products(product_id)
      )
      ''');

      //TABLA CREDITOS
    await db.execute('''
      CREATE TABLE credits (
          credit_id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER NOT NULL,
          client_id INTEGER NOT NULL,
          seller_id INTEGER NOT NULL,
          total_amount NUMERIC NOT NULL,
          total_surcharge NUMERIC NOT NULL,
          outstanding_balance NUMERIC NOT NULL,
          start_date TEXT NOT NULL,   -- formato 'YYYY-MM-DD'
          due_date TEXT DEFAULT NULL,
          status INTEGER DEFAULT '1',  -- 0=INACTIVO 1=ACTIVO SIN RECARGO 2=ATIVO CON RECARGO
          observations TEXT,
          FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
          FOREIGN KEY (client_id) REFERENCES clients(client_id),
          FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
      )
      ''');


      //TABLA PAGOS
    await db.execute('''
        CREATE TABLE payments (
          payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER,
          credit_id INTEGER,
          seller_id INTEGER NOT NULL,
          payment_method_id INTEGER NOT NULL,
          payment_date TEXT DEFAULT (datetime('now','localtime')),
          amount_paid NUMERIC NOT NULL CHECK(amount_paid >= 0),
          remaining_balance NUMERIC NOT NULL CHECK(remaining_balance >= 0),
          payment_receipt TEXT,
          observations TEXT,
        FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
        FOREIGN KEY (credit_id) REFERENCES credits(credit_id),
        FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
      
      )
      ''');


      // TABLA RECORRIDOS - REGISTRO DE RUTA
    await db.execute('''
      CREATE TABLE route_log (
          log_id INTEGER PRIMARY KEY AUTOINCREMENT,
          route_id INTEGER NOT NULL,
          number_visits INTEGER DEFAULT '0',
          status INTEGER DEFAULT '1', -- 0=FINALIZADO 1=EN PROCESO
          start_date TEXT NOT NULL DEFAULT (datetime('now','localtime')),
          end_date TEXT,
          observations TEXT,
          FOREIGN KEY (route_id) REFERENCES routes(route_id)
      )
      ''');

      // TABLA CLIENTE_VISITAS
    await db.execute('''
      CREATE TABLE client_visits (
          visit_id INTEGER PRIMARY KEY AUTOINCREMENT,
          log_id INTEGER,
          client_id INTEGER NOT NULL,
          seller_id INTEGER NOT NULL,
          visit_date TEXT NOT NULL DEFAULT (datetime('now','localtime')),
          status INTEGER NOT NULL DEFAULT 0, -- ESTADOS 0=PENDIENTE, 1=NO ESTABA 2=VISITADO, 3=VISITADO CON COMPRA O ABONO
          observations TEXT,
          FOREIGN KEY (log_id) REFERENCES route_log(log_id),
          FOREIGN KEY (client_id) REFERENCES clients(client_id),
          FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
      )
      ''');

  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
