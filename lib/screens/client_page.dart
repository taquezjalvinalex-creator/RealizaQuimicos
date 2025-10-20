import 'package:flutter/material.dart';
import 'package:proyecto_uno/models/client_model.dart';
import 'package:proyecto_uno/controllers/client_dao.dart';
import 'package:proyecto_uno/screens/bottom_sheets/add_product_bottomsheet.dart';
import 'package:proyecto_uno/screens/bottom_sheets/add_visit_bottomsheet.dart';
import 'package:proyecto_uno/style/styles.dart';
import '../controllers/route_dao.dart';
import '../routes/app_routes.dart';
import 'bottom_sheets/add_payment_bottomsheet.dart';

//import '../widgets/app_drawer.dart';

class ClientPage extends StatefulWidget {
  final int routeId;
  const ClientPage(
      {super.key, required this.routeId}
      );

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final clientDao = ClientDao();
  final routeDao = RouteDao();
  late Future <String> _routeNameFuture;
  late Future<List<ClientModel>> _clientsFuture;
  late Future <String> _statusFuture;

  @override
  void initState() {
    super.initState();
    _loadClients(); // Carga los clientes al iniciar el widget
  }

  // ✅ 1. CREA UNA FUNCIÓN PARA CARGAR/RECARGAR
  void _loadClients() {
    int routeId = widget.routeId;
    setState(() {
      if (routeId == 0) {
        _clientsFuture = clientDao.getAllClients();
        _routeNameFuture = Future.value("Clientes");
      } else {
        _routeNameFuture = routeDao.getRouteName(routeId);
        _clientsFuture = clientDao.getClientByRoute(routeId);
      }
    });
  }

    String _getStatusText(int status) {
    switch (status) {
      case 1:
        return "No estaba";
      case 2:
        return "Visitado";
      case 3:
        return "Visitado";
      default:
        return "Pendiente";
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return AppColors.dangerColor;
      case 2:
        return AppColors.successColor;
      case 3:
        return AppColors.successColor;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // ESPERAMOS EL RESULTADO DE LA CONSULTA PARA OBTENER EL NOMBRE DE LA RUTA
        title: FutureBuilder<String>(
          future: _routeNameFuture, // 1. Pasa tu Future aquí
          builder: (context, snapshot) {
            // 2. Comprueba el estado del Future
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtiene el nombre
              return const Text("Cargando...", style: AppTextStyles.title);
            }
            if (snapshot.hasError) {
              // Muestra un mensaje de error si falla
              return const Text("Error", style: AppTextStyles.title);
            }
            if (snapshot.hasData) {
              // 3. Si tiene datos, usa el resultado en el widget Text
              return Text(snapshot.data!, style: AppTextStyles.title);
            }
            // Estado por defecto mientras no se cumple ninguna de las anteriores
            return const Text("Clientes", style: AppTextStyles.title);
          },
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ClientModel>>(
        future: _clientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay clientes en esta ruta"));
          }

          final clients = snapshot.data!;
          //debugPrint(clients.map((c) => c.status).toList().toString()); //IMPRIMIR
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre + fecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // Convertimos el texto en un widget InkWell para que sea clicleable
                            child: InkWell(
                              onTap: () {
                                // pushNamed empuja la nueva página sobre la actual.
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.clientDetail,
                                  arguments: client.clientId, // Pasa el clientId como argumento
                                );
                              },
                              child: Padding(
                                // Añadimos un pequeño padding para que el área de clic sea más grande
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "${client.firstName} ${client.lastName}",
                                  style: AppTextStyles.subtitle,
                                ),
                              ),
                            ),
                          ),

                          const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.greyLight),
                          const SizedBox(width: 4),
                          Text(client.lastVisits)
                        ],
                      ),
                      //const SizedBox(height: 5),
                      // Dirección - Estatus
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.dangerColor),
                          const SizedBox(width: 4),
                          Expanded(child: Text(client.address)),

                          //Boton de estado de visita
                          InkWell(
                            onTap: () async { //Accion al presionar boton

                              // Si el estado es 2 ('Visitado') o 3 ('Visitado con compra/abono'), no hagas nada.
                              if (client.status == 2 || client.status == 3) {
                                // Opcional: Muestra un SnackBar para informar al usuario
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Este cliente ya fue visitado.'),
                                    backgroundColor: AppColors.infoColor, // Un color informativo
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return; // Detiene la ejecución de la función aquí.
                              }

                              // Abrir BottomSheet
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // permite que suba al escribir en inputs
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return AddVisitBottomSheet(
                                      clientId: client.clientId,
                                      //sellerId: client.clientId,
                                      //routeId: client.routeId
                                  );
                                },
                              );
                              // SI EL RESULTADO ES 'true', RECARGA LA LISTA
                              if (result == true) {
                                _loadClients();
                              }
                            },
                            borderRadius: BorderRadius.circular(20), // para efecto splash redondo
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary, // fondo del botón
                                borderRadius: BorderRadius.circular(20), // bordes redondos
                                border: Border.all(
                                  color: _getStatusColor(client.status), // borde con el color del estado
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getStatusText(client.status),
                                style: TextStyle(
                                  color: _getStatusColor(client.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Teléfono
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: AppColors.greyLight),
                          const SizedBox(width: 4),
                          Text(client.phone),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Abono y saldo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Abono: \$${client.payments.toStringAsFixed(0)}",
                              style:  AppTextStyles.boldSuccess),
                          Text("Saldo: \$${client.credits.toStringAsFixed(0)}",
                              style:  AppTextStyles.boldInfo),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Botones AGREGAR ABONO Y AGREGAR PRODUCTO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: AppButtonStyles.secondaryButton,
                            onPressed: () async { //  TIPO DE BOTON ASINCRONICO
                              // Abrir BottomSheet
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // permite que suba al escribir en inputs
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  String clientName = "${client.firstName} ${client.lastName}";
                                  // Parametros del BottomSheet
                                  return AddPaymentBottomSheet(
                                      clientId: client.clientId,
                                      routeId: client.routeId,
                                      clientName: clientName,
                                      clientCredits: client.credits, //Valor de saldo
                                  );

                                },
                              );
                              // SI EL RESULTADO ES 'true', RECARGA LA LISTA
                              if (result == true) {
                                _loadClients();
                              }
                            },
                            child: const Text("Agregar Abono"),
                          ),
                          ElevatedButton(
                            style: AppButtonStyles.primaryButton,
                            onPressed: () async{
                              // Abrir BottomSheet
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // permite que suba al escribir en inputs
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  String clientName = "${client.firstName} ${client.lastName}";
                                  return AddProductBottomSheet(
                                      clientId: client.clientId,
                                      clientName: clientName,
                                  );
                                },
                              );
                              // SI EL RESULTADO ES 'true', RECARGA LA LISTA
                              if (result == true) {
                                _loadClients();
                              }
                            },
                            child: const Text("Agregar Producto"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(), // Hace el botón perfectamente redondo
        elevation: 8,                // Le da un poco de sombra
        child: const Icon(
          Icons.add,
          size: 38,                  // Icono un poco más grande para destacar
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.clientForm,
            arguments: null,
          );
        },
        //child: const Icon(Icons.add, size: 32,),
      ),
    );
  }
}
