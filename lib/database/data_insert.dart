import 'database.dart';

class DataInsert {
  final dbHelper = DBRealezaQuimicos.instance;

  Future<void> insertInitialData() async {
    final db = await dbHelper.database;


    //    -- USUARIOS
    await db.execute("""
        INSERT INTO users (email, password, role, created_at, updated_at) 
        VALUES 
        ('ADMIN', 'ADMIN', 'ADMIN', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('VENDEDOR1', 'VENDEDOR1', 'VENDEDOR', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('VENDEDOR2', 'VENDEDOR2', 'VENDEDOR', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CLIENTE001@REALEZAQUIMICOS.COM', 'CLIENTE001', 'CLIENTE', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CLIENTE002@REALEZAQUIMICOS.COM', 'CLIENTE002', 'CLIENTE', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CLIENTE003@REALEZAQUIMICOS.COM', 'CLIENTE003', 'CLIENTE', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CLIENTE004@REALEZAQUIMICOS.COM', 'CLIENTE004', 'CLIENTE', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CLIENTE005@REALEZAQUIMICOS.COM', 'CLIENTE005', 'CLIENTE', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);

    //    -- MUNICIPIOS
    await db.execute("""
        INSERT INTO municipios (municipio_id, name, departamento, created_at, updated_at) 
        VALUES 
        ('19001', 'POPAYAN', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19130', 'CAJIBIO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19256', 'EL TAMBO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19355', 'INZA', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19364', 'JAMBALO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19473', 'MORALES', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19397', 'LA VEGA', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19548', 'PIENDAMO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19585', 'PURACE', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19622', 'ROSAS', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19743', 'SILVIA', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19760', 'SOTARA', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19807', 'TIMBIO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('19824', 'TOTORO', 'CAUCA', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);


    //    --RUTAS
    await db.execute("""
        INSERT INTO routes (name, municipio_id, created_at, updated_at, route_day) 
        VALUES 
        ('LA PAZ', '19001', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('ALTO GRANDE', '19130', '2025-09-18 10:30:00', '2025-09-18 10:30:00','2'),
        ('CUATRO ESQUINAS', '19256', '2025-09-18 10:30:00', '2025-09-18 10:30:00','3'),
        ('PEDREGAL', '19355', '2025-09-18 10:30:00', '2025-09-18 10:30:00','4'),
        ('NUEVA COLONIA', '19364', '2025-09-18 10:30:00', '2025-09-18 10:30:00','5'),
        ('AGUA NEGRA', '19473', '2025-09-18 10:30:00', '2025-09-18 10:30:00','6'),
        ('CABECERA MUNICIPAL', '19397', '2025-09-18 10:30:00', '2025-09-18 10:30:00','7'),
        ('LA SOMBRILLA', '19548', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('NUEVO COCONUCO', '19585', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('PARRAGA', '19622', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('GUAMBIA', '19743', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('EL RECUERDO', '19760', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('CAMPO ALEGRE', '19807', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1'),
        ('POLINDARA', '19824', '2025-09-18 10:30:00', '2025-09-18 10:30:00','1');
        """);


    //    -- VENDEDORES
    await db.execute("""
        INSERT INTO sellers (user_id, first_name, last_name, phone, document_number, hire_date, status, address, created_at, updated_at) 
        VALUES 
        ('2', 'JULIAN RICARDO', 'MERA BENAVIDEZ', '3107896559', '1060235489', '2025-09-01', '1', 'POPAYAN', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('3', 'CARLOS', 'COLLAZOS VASQUEZ', '3154689752', '1061778954', '2025-09-01', '1', 'POPAYAN', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);


    //    -- CLIENTES
    await db.execute("""
        INSERT INTO clients (user_id, route_id, first_name, last_name, document_type, document_number, phone, address, latitude, longitude, home_photo_url, reference_description, status, created_at, updated_at) 
        VALUES
        ('4', '1', 'JUAN', 'PEREZ', 'CC', '12345678', '3102345678', 'CALLE 12 # 34-56', '5123456', '-75123456', 'https://picsum.photos/seed/1/400/300', 'CASA DE DOS PISOS CERCA DE LA ESQUINA', '1', '2025-09-18 15:30:00', '2025-09-18 15:30:00'),
        ('5', '2', 'MARIA', 'GOMEZ', 'TI', '9876543', '3209876543', 'CARRERA 45 # 67-89', '6234567', '-74987654', 'https://picsum.photos/seed/2/400/300', 'FRENTE A LA PANADERIA DEL BARRIO', '1', '2025-09-18 15:30:00', '2025-09-18 15:30:00'),
        ('6', '3', 'CARLOS', 'LOPEZ', 'CC', '45678901', '3004567890', 'AV PRINCIPAL # 12-34', '7345678', '-73876543', 'https://picsum.photos/seed/3/400/300', 'JUNTO A LA TIENDA EL PROGRESO', '1', '2025-09-19 10:30:00', '2025-09-19 10:30:00'),
        ('7', '4', 'ANA', 'MARTINEZ', 'CE', '11223344', '3111234567', 'CALLE 89 # 45-67', '8456789', '-72765432', 'https://picsum.photos/seed/4/400/300', 'APARTAMENTO 302 TORRE B', '1', '2025-09-19 10:30:00', '2025-09-19 10:30:00'),
        ('8', '5', 'PEDRO', 'RODRIGUEZ', 'CC', '1060259875', '3129876543', 'CARRERA 56 # 78-90', '9567890', '-71654321', 'https://picsum.photos/seed/5/400/300', 'CASA COLOR BLANCO CON PORTON CAFE', '1', '2025-09-19 10:30:00', '2025-09-19 10:30:00'),
        (NULL, '6', 'LAURA', 'FERNANDEZ', 'CC', '33445566', '3167654321', 'CALLE 23 # 45-12', '4678901', '-76543210', 'https://picsum.photos/seed/6/400/300', 'DIAGONAL AL COLEGIO SAN JOSE', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '7', 'ANDRES', 'TORRES', 'CC', '77889900', '3146543210', 'CARRERA 10 # 11-22', '3789012', '-75432109', 'https://picsum.photos/seed/7/400/300', 'CASA ESQUINERA DE LADRILLO A LA VISTA', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '8', 'LUISA', 'RAMIREZ', 'TI', '4455667', '3155432109', 'AV CENTRAL # 55-66', '2890123', '-74321098', 'https://picsum.photos/seed/8/400/300', 'FRENTE AL PARQUE PRINCIPAL', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '9', 'MIGUEL', 'CASTILLO', 'CC', '99887766', '3184321098', 'CALLE 77 # 88-99', '1901234', '-73210987', 'https://picsum.photos/seed/9/400/300', 'CASA CON REJA VERDE', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '10', 'SOFIA', 'JIMENEZ', 'CC', '22334455', '3173210987', 'CARRERA 99 # 00-11', '912345', '-72109876', 'https://picsum.photos/seed/10/400/300', 'APARTAMENTO PISO 5', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '11', 'JORGE', 'MORENO', 'CE', '55667788', '3102109876', 'CALLE 34 # 56-78', '10123456', '-70987654', 'https://picsum.photos/seed/11/400/300', 'DETRAS DE LA IGLESIA CENTRAL', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '12', 'PATRICIA', 'VARGAS', 'CC', '66778899', '3121098765', 'CARRERA 22 # 33-44', '11234567', '-71876543', 'https://picsum.photos/seed/12/400/300', 'CASA CON MURAL DE COLORES', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '13', 'OSCAR', 'GUTIERREZ', 'CC', '44552211', '3119988776', 'AV NORTE # 77-88', '12345678', '-72765432', 'https://picsum.photos/seed/13/400/300', 'JUNTO A LA ESTACION DE BUSES', '1', '2025-09-20 10:30:00', '2025-09-20 10:30:00'),
        (NULL, '14', 'ELENA', 'RIOS', 'TI', '3344112', '3208877665', 'CALLE 56 # 12-34', '13456789', '-73654321', 'https://picsum.photos/seed/14/400/300', 'FRENTE AL SUPERMERCADO', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '1', 'FABIAN', 'PINEDA', 'CC', '11229900', '3157766554', 'CARRERA 44 # 55-66', '14567890', '-74543210', 'https://picsum.photos/seed/15/400/300', 'CASA DE TECHO ROJO', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '2', 'NATALIA', 'CRUZ', 'CC', '1062159865', '3166655443', 'AV SUR # 22-33', '15678901', '-75432109', 'https://picsum.photos/seed/16/400/300', 'AL LADO DE LA CANCHA DE FUTBOL', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '3', 'HUGO', 'SALAZAR', 'CC', '77885566', '3175544332', 'CALLE 11 # 99-00', '16789012', '-76321098', 'https://picsum.photos/seed/17/400/300', 'CASA ESQUINERA PINTADA DE AZUL', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '4', 'CAMILA', 'MENDOZA', 'CC', '66770811', '3184433221', 'CARRERA 88 # 77-66', '17890123', '-77210987', 'https://picsum.photos/seed/18/400/300', 'APARTAMENTO TORRE 1 PISO 8', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '5', 'FERNANDO', 'DIAZ', 'CC', '99880022', '3193322110', 'CALLE 22 # 11-90', '18901234', '-78109876', 'https://picsum.photos/seed/19/400/300', 'CASA DE MADERA JUNTO AL RIO', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '6', 'CLARA', 'NAVARRO', 'CE', '22334499', '3132211009', 'CARRERA 33 # 22-80', '19012345', '-79987654', 'https://picsum.photos/seed/20/400/300', 'FRENTE AL HOSPITAL MUNICIPAL', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '7', 'DIEGO', 'CORTES', 'CC', '88990061', '3121100998', 'AV CENTRAL # 66-77', '20123456', '-78876543', 'https://picsum.photos/seed/21/400/300', 'CASA AMARILLA CON JARDIN', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '8', 'LUCIA', 'MARTINEZ', 'CC', '44558877', '3110099887', 'CALLE 90 # 12-34', '21234567', '-77765432', 'https://picsum.photos/seed/22/400/300', 'A UNA CUADRA DE LA ALCALDIA', '1', '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
        (NULL, '9', 'ESTEBAN', 'ARIAS', 'CC', '55669988', '3109988776', 'CARRERA 21 # 43-22', '22345678', '-76654321', 'https://picsum.photos/seed/23/400/300', 'CASA CON BALCON VERDE', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '10', 'SANDRA', 'ORTIZ', 'TI', '6677002', '3198877665', 'CALLE 78 # 32-10', '23456789', '-75543210', 'https://picsum.photos/seed/24/400/300', 'APARTAMENTO 202 TORRE C', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '11', 'RICARDO', 'SUAREZ', 'CC', '77881122', '3187766554', 'AV NORTE # 12-65', '24567890', '-74432109', 'https://picsum.photos/seed/25/400/300', 'DIAGONAL A LA BIBLIOTECA', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '12', 'PABLO', 'MORALES', 'CC', '44551234', '3112233445', 'CALLE 30 # 22-56', '5345678', '-74123456', 'https://picsum.photos/seed/26/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '13', 'VERONICA', 'SUAREZ', 'TI', '1122445', '3209876543', 'CARRERA 77 # 11-23', '7567890', '-73876543', 'https://picsum.photos/seed/27/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '14', 'RAFAEL', 'REYES', 'NIT', '900876543', '6001234567', 'AV SUR # 45-78', '10876543', '-74654321', 'https://picsum.photos/seed/28/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '1', 'CRISTINA', 'PAZ', 'CC', '66779900', '3123459876', 'CALLE 12 # 33-10', '8123456', '-75567890', 'https://picsum.photos/seed/29/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '2', 'ESTEBAN', 'LEON', 'CC', '12375678', '3162349876', 'CARRERA 23 # 88-11', '2876543', '-76987654', 'https://picsum.photos/seed/30/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '3', 'BEATRIZ', 'CASTRO', 'CE', '45678912', '3194561234', 'CALLE 7 # 23-45', '9234567', '-72345678', 'https://picsum.photos/seed/31/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '4', 'RAUL', 'ORTIZ', 'CC', '99881234', '3172345678', 'AV CENTRAL # 10-11', '4567890', '-74876543', 'https://picsum.photos/seed/32/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '5', 'LORENA', 'VARGAS', 'CC', '1602356698', '3148765432', 'CARRERA 15 # 21-22', '6987654', '-73654321', 'https://picsum.photos/seed/33/400/300', 'CASA CON REJA ROJA', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '6', 'DANIELA', 'MENDOZA', 'CC', '55663344', '3107654321', 'CALLE 18 # 34-56', '3456789', '-75987654', 'https://picsum.photos/seed/34/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '7', 'HECTOR', 'LOPEZ', 'TI', '7788445', '3186547890', 'AV NORTE # 12-67', '8654321', '-74123456', 'https://picsum.photos/seed/35/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '8', 'CARLA', 'RAMIREZ', 'CC', '44556611', '3127651234', 'CARRERA 5 # 98-21', '11345678', '-70987654', 'https://picsum.photos/seed/36/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '9', 'ROBERTO', 'SILVA', 'CE', '22334412', '3151239876', 'CALLE 66 # 43-22', '5123456', '-76234567', 'https://picsum.photos/seed/37/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '10', 'ADRIANA', 'GOMEZ', 'CC', '99881122', '3012345670', 'CARRERA 1 # 45-11', '7567890', '-72876543', 'https://picsum.photos/seed/38/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-22 10:30:00', '2025-09-22 10:30:00'),
        (NULL, '11', 'SAMUEL', 'CASTRO', 'CC', '44557788', '3176541234', 'CALLE 77 # 89-32', '6234567', '-73456789', 'https://picsum.photos/seed/39/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '12', 'VERONICA', 'ROJAS', 'CC', '1061774897', '3140987654', 'AV CENTRAL # 55-12', '8123456', '-74345678', 'https://picsum.photos/seed/40/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '13', 'VICTOR', 'HERRERA', 'CC', '33441122', '3198760123', 'CARRERA 90 # 23-44', '4987654', '-75567890', 'https://picsum.photos/seed/41/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '14', 'SILVIA', 'CARDENAS', 'TI', '1122334', '3136789012', 'CALLE 23 # 12-90', '5876543', '-72987654', 'https://picsum.photos/seed/42/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '1', 'ARTURO', 'DIAZ', 'CC', '22339900', '3201234567', 'AV SUR # 33-11', '9456789', '-74876543', 'https://picsum.photos/seed/43/400/300', 'CASA CON REJA ROJA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '2', 'MONICA', 'SANCHEZ', 'CE', '55667722', '3110987654', 'CALLE 14 # 45-21', '7345678', '-73654321', 'https://picsum.photos/seed/44/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '3', 'IVAN', 'PEREZ', 'CC', '66771123', '3176543219', 'CARRERA 32 # 76-54', '2987654', '-76543210', 'https://picsum.photos/seed/45/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '4', 'NADIA', 'TORRES', 'CC', '1061235486', '3128765430', 'CALLE 18 # 56-33', '6789012', '-73210987', 'https://picsum.photos/seed/46/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '5', 'MAURICIO', 'CRUZ', 'CC', '77887122', '3109876501', 'CARRERA 19 # 12-65', '10345678', '-74109876', 'https://picsum.photos/seed/47/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '6', 'CLAUDIA', 'REYES', 'CC', '88992233', '3165432189', 'CALLE 22 # 98-12', '8234567', '-72765432', 'https://picsum.photos/seed/48/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '7', 'DAVID', 'SALAZAR', 'TI', '99882211', '3187654320', 'CARRERA 67 # 43-22', '5345678', '-74654321', 'https://picsum.photos/seed/49/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '8', 'CRISTINA', 'ROMERO', 'CC', '44553377', '3159876542', 'CALLE 11 # 54-32', '9876543', '-73876543', 'https://picsum.photos/seed/50/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '9', 'JORGE', 'MEDINA', 'CC', '55669900', '3198765412', 'CARRERA 45 # 33-90', '6543210', '-75876543', 'https://picsum.photos/seed/51/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '10', 'LAURA', 'NUNEZ', 'CC', '1060253358', '3137654321', 'CALLE 20 # 12-11', '7890123', '-72456789', 'https://picsum.photos/seed/52/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '11', 'CAMILA', 'CANO', 'CC', '22334466', '3120987654', 'CARRERA 55 # 22-34', '3987654', '-73987654', 'https://picsum.photos/seed/53/400/300', 'CASA CON REJA ROJA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '12', 'OSCAR', 'SOSA', 'TI', '7788991', '3008765432', 'CALLE 17 # 88-21', '5876543', '-72654321', 'https://picsum.photos/seed/54/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '13', 'MARIANA', 'PAZ', 'CC', '11224466', '3165439870', 'CARRERA 78 # 21-65', '9456789', '-74567890', 'https://picsum.photos/seed/55/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '14', 'LUIS', 'GUTIERREZ', 'CE', '33445577', '3177654321', 'CALLE 45 # 19-10', '2345678', '-75123456', 'https://picsum.photos/seed/56/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '1', 'ANA', 'BENITEZ', 'CC', '88990011', '3187654329', 'AV NORTE # 12-33', '11345678', '-70876543', 'https://picsum.photos/seed/57/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '2', 'DIEGO', 'ROMERO', 'CC', '44556699', '3123450987', 'CALLE 66 # 77-54', '7567890', '-74210987', 'https://picsum.photos/seed/58/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '3', 'PAULA', 'ARIAS', 'CC', '1061223586', '3156784321', 'CARRERA 23 # 43-22', '5234567', '-72876543', 'https://picsum.photos/seed/59/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '4', 'JORGE', 'REYES', 'CC', '66770022', '3198765433', 'CALLE 90 # 32-11', '8654321', '-74567890', 'https://picsum.photos/seed/60/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '5', 'LUCIA', 'PINEDA', 'CE', '99887722', '3145678901', 'CARRERA 12 # 44-33', '4567890', '-75654321', 'https://picsum.photos/seed/61/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '6', 'NATALIA', 'GUERRERO', 'CC', '33445511', '3136789011', 'CALLE 23 # 56-12', '9876543', '-73123456', 'https://picsum.photos/seed/62/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '7', 'RAUL', 'PEREZ', 'TI', '1122330', '3176543218', 'CARRERA 19 # 87-43', '6987654', '-72345678', 'https://picsum.photos/seed/63/400/300', 'CASA CON REJA ROJA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '8', 'CAROLINA', 'MORALES', 'CC', '22334477', '3187654324', 'CALLE 11 # 22-90', '5345678', '-74876543', 'https://picsum.photos/seed/64/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '9', 'MIGUEL', 'SALAZAR', 'CC', '44558822', '3012345679', 'CARRERA 23 # 65-11', '3876543', '-73765432', 'https://picsum.photos/seed/65/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '10', 'ISABELLA', 'DIAZ', 'CC', '1032254789', '3109876542', 'CALLE 14 # 32-65', '7234567', '-75987654', 'https://picsum.photos/seed/66/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '11', 'SOFIA', 'CASTRO', 'CE', '77889912', '3145673210', 'CARRERA 45 # 90-21', '8987654', '-74345678', 'https://picsum.photos/seed/67/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '12', 'DAVID', 'RAMIREZ', 'CC', '11225544', '3156789012', 'CALLE 90 # 87-23', '5654321', '-72987654', 'https://picsum.photos/seed/68/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '13', 'GABRIELA', 'FLORES', 'TI', '8899112', '3167890124', 'CARRERA 66 # 22-43', '4987654', '-74567890', 'https://picsum.photos/seed/69/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '14', 'SERGIO', 'VARGAS', 'CC', '99884433', '3176543217', 'CALLE 23 # 45-12', '9876543', '-73234567', 'https://picsum.photos/seed/70/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '1', 'ADRIANA', 'SUAREZ', 'CC', '55667790', '3187654300', 'AV CENTRAL # 12-76', '2345678', '-75987654', 'https://picsum.photos/seed/71/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '2', 'CAMILA', 'ROJAS', 'CE', '44557722', '3198765435', 'CARRERA 23 # 44-32', '6876543', '-72654321', 'https://picsum.photos/seed/72/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '3', 'LAURA', 'ORTIZ', 'CC', '66770011', '3134567891', 'CALLE 11 # 65-23', '11234567', '-70765432', 'https://picsum.photos/seed/73/400/300', 'CASA CON REJA ROJA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '4', 'FELIPE', 'CANO', 'TI', '99883344', '3178901234', 'CARRERA 78 # 21-34', '9345678', '-73987654', 'https://picsum.photos/seed/74/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '5', 'CLAUDIA', 'HERRERA', 'CC', '11229988', '3125678901', 'CALLE 45 # 98-76', '7123456', '-72876543', 'https://picsum.photos/seed/75/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '6', 'SAMUEL', 'GOMEZ', 'CC', '44559900', '3109876532', 'CARRERA 23 # 44-32', '6987654', '-74654321', 'https://picsum.photos/seed/76/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '7', 'VERONICA', 'MARTINEZ', 'CC', '1060235698', '3198765439', 'CALLE 11 # 23-43', '5876543', '-72345678', 'https://picsum.photos/seed/77/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '8', 'CRISTINA', 'LOPEZ', 'CE', '77889913', '3129876543', 'CARRERA 77 # 98-12', '7234567', '-73654321', 'https://picsum.photos/seed/78/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '9', 'RAFAEL', 'GUTIERREZ', 'CC', '22336655', '3146789012', 'CALLE 88 # 77-34', '9876543', '-74876543', 'https://picsum.photos/seed/79/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '10', 'LUCIA', 'DIAZ', 'TI', '8899002', '3151234567', 'CARRERA 55 # 66-22', '2345678', '-76234567', 'https://picsum.photos/seed/80/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '11', 'OSCAR', 'MEDINA', 'CC', '44551123', '3177654326', 'CALLE 43 # 23-90', '10234567', '-70987654', 'https://picsum.photos/seed/81/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '12', 'ANA', 'ROJAS', 'CC', '66779988', '3181234560', 'CARRERA 76 # 21-11', '6345678', '-72876543', 'https://picsum.photos/seed/82/400/300', 'APARTAMENTO 4B TORRE 2', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '13', 'JORGE', 'VARGAS', 'CE', '11224477', '3139876543', 'CALLE 22 # 11-34', '8987654', '-74567890', 'https://picsum.photos/seed/83/400/300', 'CASA CON REJA ROJA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '14', 'CAROLINA', 'GUZMAN', 'CC', '33446677', '3196543210', 'CARRERA 34 # 87-65', '7123456', '-75345678', 'https://picsum.photos/seed/84/400/300', 'CERCA DEL POLIDEPORTIVO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '1', 'MIGUEL', 'ROMERO', 'TI', '55667723', '3127654322', 'CALLE 77 # 23-98', '4234567', '-73654321', 'https://picsum.photos/seed/85/400/300', 'BARRIO LA ESPERANZA CASA 12', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '2', 'PAULA', 'MORALES', 'CC', '99882233', '3145678098', 'CARRERA 89 # 12-43', '9654321', '-74234567', 'https://picsum.photos/seed/86/400/300', 'CERCA DEL PUNTO DE TRANSPORTE', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '3', 'ISABELLA', 'SALAZAR', 'CC', '44556633', '3117654323', 'CALLE 45 # 65-12', '8234567', '-72987654', 'https://picsum.photos/seed/87/400/300', 'VECINO JOSE PEREZ CASA AZUL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '4', 'SOFIA', 'PINEDA', 'CC', '1032256489', '3106789011', 'CARRERA 56 # 76-23', '5876543', '-73876543', 'https://picsum.photos/seed/88/400/300', 'FRENTE A LA ESCUELA LOCAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '5', 'DAVID', 'SUAREZ', 'CE', '77889914', '3165432109', 'CALLE 12 # 98-32', '6987654', '-72567890', 'https://picsum.photos/seed/89/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '6', 'GABRIELA', 'CARDENAS', 'CC', '22339922', '3187654321', 'CARRERA 98 # 45-65', '2876543', '-75987654', 'https://picsum.photos/seed/90/400/300', 'A UN COSTADO DE LA IGLESIA', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '7', 'RAUL', 'CRUZ', 'TI', '8899222', '3123456788', 'CALLE 11 # 33-22', '9876543', '-74876543', 'https://picsum.photos/seed/91/400/300', 'DETRAS DE LA PLAZA CENTRAL', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00'),
        (NULL, '8', 'MONICA', 'ORTIZ', 'CC', '66778812', '3157654321', 'CARRERA 65 # 32-10', '11345678', '-6987654', 'https://picsum.photos/seed/79/400/300', 'ALTOS DEL BARRIO SAN PEDRO', '1', '2025-09-23 10:30:00', '2025-09-23 10:30:00');
        """);


    //    -- VENDEDORES RUTAS
    await db.execute("""
        INSERT INTO seller_routes (seller_id, route_id, assignment_date, status, observations) 
        VALUES 
        ('1', '1', '2025-09-18', '1', 'REASIGNADO POR COBERTURA DE OTRA ZONA'),
        ('2', '2', '2025-09-18', '1', ''),
        ('1', '3', '2025-09-18', '1', ''),
        ('2', '4', '2025-09-18', '1', ''),
        ('1', '5', '2025-09-18', '1', ''),
        ('2', '6', '2025-09-18', '1', ''),
        ('1', '7', '2025-09-18', '1', ''),
        ('2', '8', '2025-09-18', '1', ''),
        ('1', '9', '2025-09-18', '1', ''),
        ('2', '10', '2025-09-18', '1', ''),
        ('1', '11', '2025-09-18', '1', ''),
        ('2', '12', '2025-09-18', '1', ''),
        ('1', '13', '2025-09-18', '1', ''),
        ('2', '14', '2025-09-18', '1', '');
        """);


    //    --CATEGORIAS
    await db.execute("""
        INSERT INTO categories (name, description, status, created_at, updated_at) 
        VALUES 
        ('LIMPIEZA Y DESINFECCI�N DEL HOGAR', 'PRODUCTOS DISE�ADOS PARA MANTENER LOS ESPACIOS LIMPIOS, LIBRES DE G�RMENES Y CON UN AMBIENTE HIGI�NICO.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CUIDADO Y LAVADO DE ROPA', 'FORMULADOS PARA PROTEGER, SUAVIZAR Y MANTENER LA FRESCURA DE LAS PRENDAS.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CERAS Y ABRILLANTADORES', 'PRODUCTOS PARA DAR BRILLO, PROTEGER SUPERFICIES Y REALZAR ACABADOS.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CUIDADO PERSONAL', 'PRODUCTOS ORIENTADOS AL BIENESTAR, LA HIGIENE Y LA FRESCURA DIARIA.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('AMBIENTADORES Y AROMATIZANTES', 'FRAGANCIAS PARA MANTENER LOS ESPACIOS CON UN AROMA AGRADABLE Y DURADERO.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CONTROL DE PLAGAS', 'SOLUCIONES EFECTIVAS PARA LA ELIMINACI�N Y PREVENCI�N DE INSECTOS Y ROEDORES.', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);


    //    --PRODUCTOS
    await db.execute("""
        INSERT INTO products (name, code, description, unit_price, surcharge, minimum_stock,	unit_measure, category_id, availability, status, created_at, updated_at) 
        VALUES 
        ('JABÓN LÍQUIDO MULTIUSOS', 'JB', 'IDEAL PARA LA LIMPIEZA GENERAL DE SUPERFICIES.', '20000', '4000', '20', 'ML', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('JABÓN NEUTRO', 'JN', 'LIMPIEZA SUAVE Y EFICAZ PARA M�LTIPLES USOS.', '20000', '4000', '15', 'G', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('JABÓN DE MANOS', 'JM', 'HIGIENIZA Y CUIDA LAS MANOS DIARIAMENTE.', '13000', '2000', '20', 'ML', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('L�MPIDO', 'LP', 'POTENTE DESINFECTANTE PARA ELIMINAR G�RMENES.', '10000', '100', '30', 'ML', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('PASTILLAS DE CLORO', 'PC', 'DESINFECTA Y BLANQUEA BA�OS Y SUPERFICIES.', '14000', '2000', '50', 'UND', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('LIMPIA VIDRIOS', 'LV', 'F�RMULA ESPECIAL PARA DEJAR VIDRIOS BRILLANTES.', '10000', '2000', '25', 'ML', '1', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('DETERGENTE ROPA COLOR', 'RC', 'PROTEGE COLORES Y MANTIENE LA ROPA FRESCA.', '18000', '2000', '20', 'G', '2', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('SUAVIZANTE', 'SV', 'BRINDA SUAVIDAD Y AROMA AGRADABLE A LAS PRENDAS.', '20000', '4000', '25', 'ML', '2', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('TALCOS', 'TL', 'MANTIENE FRESCAS LAS PRENDAS Y REDUCE HUMEDAD.', '18000', '2000', '15', 'G', '2', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('PINTON (CERA PL�STICA)', 'P', 'DA BRILLO Y PROTECCI�N A PISOS PL�STICOS.', '26000', '4000', '10', 'ML', '3', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CERA ROJA', 'CR', 'RESALTA EL COLOR Y PROTEGE SUPERFICIES.', '22000', '3000', '10', 'ML', '3', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('CERA NEUTRA', 'CN', 'BRILLO NEUTRO PARA DIFERENTES SUPERFICIES.', '18000', '2000', '10', 'ML', '3', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('SILICONA PARA MOTOS', 'SL', 'PROTEGE Y DA BRILLO A PARTES DE MOTOCICLETAS.', '20000', '2000', '8', 'ML', '3', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('SHAMPOO DE HIERBAS', 'SH', 'LIMPIEZA SUAVE Y REVITALIZANTE PARA EL CABELLO.', '26000', '4000', '15', 'ML', '4', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('LOCI�N (DAMAS Y CABALLEROS)', 'LC', 'FRAGANCIA FRESCA Y DURADERA PARA USO DIARIO.', '20000', '4000', '10', 'ML', '4', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('LOCI�N PARA NI�OS', 'LCN', 'FRAGANCIA SUAVE PARA NI�OS.', '13000', '2000', '8', 'ML', '4', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('DESODORANTE', 'DR', 'CONTROLA MAL OLOR Y APORTA FRESCURA DIARIA.', '10000', '2000', '20', 'ML', '4', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('AMBIENTADOR DE PISO', 'AP', 'MANTIENE LOS PISOS CON AROMA AGRADABLE.', '18000', '2000', '20', 'ML', '5', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('AMBIENTADOR DE AIRE', 'AA', 'REFRESCA Y PERFUMA LOS ESPACIOS CERRADOS.', '16000', '2000', '20', 'ML', '5', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('ESENCIAS', 'EC', 'AROMAS CONCENTRADOS PARA PERSONALIZAR AMBIENTES.', '10000', '100', '15', 'ML', '5', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('VENENO INSECTICIDA', 'VN', 'ELIMINA Y PREVIENE LA PRESENCIA DE INSECTOS.', '20000', '100', '10', 'ML', '6', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('VENENO PARA RATAS', 'VNR', 'SOLUCI�N EFICAZ CONTRA ROEDORES.', '7000', '1000', '10', 'G', '6', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('TAC TAX', 'TT', 'CONTROL ESPECIALIZADO DE CUCARACHAS.', '16000', '2000', '15', 'G', '6', '1', '1', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);

    //    -- METODO DE PAGO
    await db.execute("""
        INSERT INTO payment_methods (name, description, qr, created_at, updated_at) 
        VALUES 
        ('EFECTIVO', 'DINERO EN FORMA DE BILLETES Y MONEDAS.', '', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('NEQUI', 'BILLETERA DIGITAL QUE OPERA A TRAVÉS DE UNA APLICACIÓN MÓVIL PARA GESTIONAR DINERO DESDE UN CELULAR.', '', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
        ('EFECTIVO-TRANSFERENCIA', '', '', '2025-09-18 10:30:00', '2025-09-18 10:30:00');
        """);


    //    -- PEDIDOS
    await db.execute("""
        INSERT INTO orders (client_id, seller_id, order_date, status, total_quantity, total_price, total_surcharge, observations) 
        VALUES 
        ('15', '1', '2025-09-18 15:30:00', 'PENDIENTE', '5', '96000', '16000', ''),
        ('29', '2', '2025-09-18 15:30:00', 'PENDIENTE', '2', '40000', '48000', ''),
        ('6', '1', '2025-09-19 10:30:00', 'PENDIENTE', '1', '18000', '20000', ''),
        ('7', '2', '2025-09-19 10:30:00', 'PENDIENTE', '1', '26000', '30000', ''),
        ('8', '1', '2025-09-19 10:30:00', 'PENDIENTE', '1', '22000', '25000', '');
        """);

    //    -- DETALLE PEDIDOS
    await db.execute("""
        INSERT INTO order_items (order_id, product_id, quantity, unit_price, surcharge, total_price, total_surcharge) 
        VALUES 
        ('1', '7', '2', '18000', '2000', '36000', '4000'),
        ('1', '8', '3', '20000', '4000', '60000', '12000'),
        ('2', '8', '2', '20000', '4000', '40000', '8000'),
        ('3', '9', '1', '18000', '2000', '18000', '2000'),
        ('4', '10', '1', '26000', '4000', '26000', '4000'),
        ('5', '11', '1', '22000', '3000', '22000', '3000');
        """);


    //    -- RECORRIDOS
    await db.execute("""
        INSERT INTO route_log (log_id, route_id, number_visits, status, start_date, end_date)
        VALUES
        ('1', '1', '6', '1', '2025-10-05 00:00:00', NULL), -- RUTA ACTUAL
        ('2', '1', '6', '0', '2025-09-23 00:00:00', '2025-09-23 23:59:59'), -- RUTA CERRADA
        ('3', '1', '1', '0', '2025-09-16 00:00:00', '2025-09-23 23:59:59');
        """);

    //    -- VISITAS
    await db.execute("""
        INSERT INTO client_visits (visit_id, client_id, seller_id, log_id, visit_date, status, observations)
        VALUES
        ('1', '1','1', '3', '2025-09-16 00:00:00', '3', 'VENTA 1 CRÉDITO 1'),
        ('14', '1','1', '3', '2025-09-16 00:00:00', '3', 'VENTA 1 CRÉDITO 1'),
        ('2', '15','1', '2', '2025-09-23 00:00:00', '3', 'VENTA 2 CRÉDITO 2'),
        ('3', '71','1', '1', '2025-10-05 00:00:00', '3', 'VENTA 3'),
        ('4', '29','1', '2', '2025-09-23 00:00:00', '3', 'VENTA 4 CRÉDITO 3'),
        ('5', '43','1', '2', '2025-09-23 00:00:00', '3', 'VENTA 5 CRÉDITO 4'),
        ('6', '71','1', '2', '2025-09-23 00:00:00', '3', 'VENTA 6'),
        ('7', '1','1', '1', '2025-10-05 00:00:00', '3', 'ABONO A CREDITO 1'),  
        ('8', '15','1', '1', '2025-10-05 00:00:00', '3', 'ABONO A CREDITO 2'),
        ('9', '29','1', '1', '2025-10-05 00:00:00', '2', 'ESTADO 2'), --SIN TRANSACCIONES
        ('10', '43','1', '1', '2025-10-05 00:00:00', '1', 'ESTADO 1'), --NO ESTABA
        ('12', '57','1', '2', '2025-09-23 00:00:00', '1', 'NO ESTA EN CASA'), -- 
        ('13', '85','1', '1', '2025-10-05 00:00:00', '3', 'VENTA 7');
        """);

    //    -- VENTAS
    await db.execute("""
        INSERT INTO sales (visit_id, client_id, seller_id, sale_date, payment_type, total_price, total_surcharge, status, observations)
        VALUES
        ('1', '1','1', '2025-09-16 00:00:00', '0', '40000', '5000', 'PENDIENTE_PAGO', ''), -- VENTA 1 CRÉDITO 1 TIENEN ABONO
        ('2', '15','1', '2025-09-23 00:00:00', '0', '40000', '5000', 'PENDIENTE_PAGO', ''), -- VENTA 2 CRÉDITO 2
        ('3', '71','1', '2025-10-05 00:00:00', '1', '20000', '0', 'PAGADO', ''), -- VENTA 3
        ('4', '29','1', '2025-09-23 00:00:00', '0', '40000', '5000', 'PENDIENTE_PAGO', ''), -- VENTA 4 CRÉDITO 3
        ('5', '43','1', '2025-09-23 00:00:00', '0', '20000', '2500', 'PENDIENTE_PAGO', ''), -- VENTA 5 CRÉDITO 4
        ('6', '71','1', '2025-09-23 00:00:00', '1', '40000', '0', 'PAGADO', ''), -- VENTA 6
        ('7', '85','1', '2025-10-05 00:00:00', '1', '25000', '0', 'PAGADO', '');
        """);


    //    --CREDITOS
    await db.execute("""
        INSERT INTO credits (sale_id, client_id, seller_id, total_amount, total_surcharge, outstanding_balance, start_date)
        VALUES     -- TOTAL  RECARGO  BALANCE
        ('1','1','1','40000','5000','20000','2025-09-23 09:00:00'), --TIENE UN ABONO DE 25000
        ('2','15','1','40000','5000','40000','2025-09-23 10:00:00'), --
        ('4','29','1','40000','5000','45000','2025-09-23 11:00:00'),
        ('5','43','1','20000','2500','22500','2025-09-23 11:30:00');
        """);

    //    --PAGOS
    await db.execute("""
        INSERT INTO payments (credit_id, payment_method_id, sale_id, seller_id, payment_date, amount_paid, remaining_balance, payment_receipt, observations)
        VALUES
        ('1', '1', '1', '1', '2025-10-05 00:00:00', '15000', '30000', NULL, ''), --CREDITO 1
        ('1', '1', '1', '1', '2025-09-23 00:00:00', '10000', '20000', NULL, ''), --CREDITO 1
        (NULL, '1', '3', '1', '2025-10-05 00:00:00', '20000', '0', NULL, ''), --VENTA 3
        (NULL, '1', '6', '1', '2025-09-23 00:00:00', '20000', '0', NULL, ''), --VENTA 6
        (NULL, '1', '7', '1', '2025-10-05 00:00:00', '25000', '0', NULL, '');
        """);
  }

}