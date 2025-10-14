import 'package:flutter/material.dart';
import 'package:proyecto_uno/widgets/app_drawer.dart'; // importa tu widget
import 'package:proyecto_uno/controllers/route_dao.dart';
import 'package:proyecto_uno/models/route_model.dart';
import 'package:proyecto_uno/style/styles.dart';

import '../routes/app_routes.dart';

class RoutesPage extends StatefulWidget {
  //final int sellerId; // Propiedad para recibir el sellerId
  //const RoutesPage({super.key, required this.sellerId});
  const RoutesPage({super.key});


  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final routeDao = RouteDao();

  late Future<List<RouteModel>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _routesFuture = routeDao.getRouteyBySeller();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de rutas"),
        centerTitle: true,
      ),

      drawer: const AppDrawer(), // 👈 aquí heredas el widget del menú

      body: FutureBuilder<List<RouteModel>>(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay rutas registradas"));
          }

          final routes = snapshot.data!;

          return ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return RutaCard(
                nombre: route.ruta,
                clientes: route.numeroClientes,
                visitas: route.clientesVisitados,
                ventas: route.ventasTotales,
                abonos: route.abonosTotales,
                color: Colors.green,
                progreso: route.clientesVisitados / route.numeroClientes,

                // ✅ 4. PASA LA ACCIÓN DE NAVEGACIÓN AQUÍ
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.clients,
                    arguments: route.rutaId, // Asegúrate que el nombre de la propiedad sea correcto
                  );
                },

              );
            },
          );
        },
      ),
    );
  }
}

class RutaCard extends StatelessWidget {
  final String nombre;
  final int clientes;
  final int visitas;
  final double ventas;
  final double abonos;
  final Color color;
  final double progreso;
  final VoidCallback? onTap; //Cliqueable

  const RutaCard({
    super.key,
    required this.nombre,
    required this.clientes,
    required this.visitas,
    required this.ventas,
    required this.abonos,
    required this.color,
    required this.progreso,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap, // Asigna la función recibida al onTap del InkWell
        borderRadius: BorderRadius.circular(16), // Para que la onda coincida con el borde
        child:Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Container(  //BORDE A LA IZQUIERDA
            /*decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: color, width: 4),
              ),
            ),*/
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre de la ruta
                Text(
                  nombre,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // ENCABEZADO Clientes, Deuda, Abonos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people, size: 18, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text("Clientes"),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 18, color: AppColors.successColor),
                        const SizedBox(width: 4),
                        Text("Abonos"),
                        //Text("Abonos \$${abonos.toString()}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 18, color: AppColors.greyLight),
                        const SizedBox(width: 4),
                        Text("Ventas"),
                      ],
                    ),
                  ],
                ),
                // DATOS Clientes, Deuda, Abonos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("          ${clientes.toString()}"),
                    Text("\$${abonos.toString()}", textAlign: TextAlign.center),
                    Text("\$${ventas.toString()}", textAlign: TextAlign.center),
                  ],
                ),

                const SizedBox(height: 12),

                // Barra de progreso
                LinearProgressIndicator(
                  value: progreso,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  color: AppColors.infoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("$visitas/$clientes"),
                  ],
                ),

              ],
            ),
          ),
        ),
    );
  }
}