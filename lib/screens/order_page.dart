import 'package:flutter/material.dart';
import 'package:proyecto_uno/models/order_model.dart';
import 'package:proyecto_uno/controllers/order_dao.dart';
import 'package:proyecto_uno/style/styles.dart';
import '../controllers/route_dao.dart';

class OrderPage extends StatefulWidget {
  final int routeId;
  const OrderPage({super.key, required this.routeId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderDao = OrderDao();
  final routeDao = RouteDao();
  late Future <String> _routeNameFuture;
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders(); // Carga los orderes al iniciar el widget
  }

  // 1. CREA UNA FUNCIÓN PARA CARGAR/RECARGAR
  void _loadOrders() {
    int routeId = widget.routeId;
    setState(() {
      if (routeId == 0) {
        _ordersFuture = orderDao.getAllOrders();
        _routeNameFuture = Future.value("Pedidos");
      } else {
        _routeNameFuture = routeDao.getRouteName(routeId);
        _ordersFuture = orderDao.getOrderByRoute(routeId);
      }
    });
  }


  String _getStatusText(String status) {
    switch (status) {
      case 'PENDIENTE':
        return 'Pendiente';
      case 'CONFIRMADO':
        return 'Pendiente';
      case 'ENTREGA_PARCIAL':
        return 'Parcial';
      case 'ENTREGADO':
        return 'Entregado';
      case 'CANCELADO':
        return 'Canselado';
      default:
        return 'Pendiete';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDIENTE':
        return AppColors.primary;
      case 'CONFIRMADO':
        return AppColors.successColor;
      case 'ENTREGA_PARCIAL':
        return AppColors.infoColor;
      case 'ENTREGADO':
        return AppColors.successColor;
      case 'CANCELADO':
        return AppColors.dangerColor;
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
          future: _routeNameFuture, // TITULO DE LA PANTALLA
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
            return const Text("Pedidos", style: AppTextStyles.title);
          },
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay orderes en esta ruta"));
          }

          final orders = snapshot.data!;
          //debugPrint(orders.map((c) => c.status).toList().toString()); //IMPRIMIR
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

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
                          Expanded(child:
                          Text(
                            "${order.clientName} ${order.clientLastName}",
                            style: AppTextStyles.subtitle,
                          ),
                          ),

                          const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.greyLight),
                          const SizedBox(width: 4),
                          Text(order.orderDate)
                        ],
                      ),
                      //const SizedBox(height: 5),
                      // Cantidad - Estatus
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.shopping_bag, size: 16, color: AppColors.successColor),
                          const SizedBox(width: 4),
                          Expanded(child: Text('Cantidad: ${order.quantity.toString()}')),

                          //Boton de estado de ENTREGA
                          InkWell(
                            onTap: () async { //Accion al presionar boton
                              /*
                              // Si el estado es 2 ('Visitado') o 3 ('Visitado con compra/abono'), no hagas nada.
                              if (order.status == 2 || order.status == 3) {
                                // Opcional: Muestra un SnackBar para informar al usuario
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Este ordere ya fue visitado.'),
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
                                      orderId: order.orderId,
                                      sellerId: order.orderId,
                                      routeId: order.routeId
                                  );
                                },
                              );
                              // ✅ 4. SI EL RESULTADO ES 'true', RECARGA LA LISTA
                              if (result == true) {
                                _loadOrders();
                              }*/
                            },
                            borderRadius: BorderRadius.circular(20), // para efecto splash redondo
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary, // fondo del botón
                                borderRadius: BorderRadius.circular(20), // bordes redondos
                                border: Border.all(
                                  color: _getStatusColor(order.status), // borde con el color del estado
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: TextStyle(
                                  color: _getStatusColor(order.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Valor del pedido
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, size: 16, color: AppColors.infoColor),
                          const SizedBox(width: 4),
                          Text('Valor: \$ ${order.totalPrice.toString()}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Vendedor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${order.sellerName} ${order.sellerLastName}",
                              style:  AppTextStyles.textGrey),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: AppButtonStyles.secondaryButton,
                            onPressed: () {/*
                              // Abrir BottomSheet
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // permite que suba al escribir en inputs
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return AddPaymentBottomSheet(orderId: order.orderId);
                                },
                              );*/
                            },
                            child: const Text("Credito"),
                          ),
                          ElevatedButton(
                            style: AppButtonStyles.primaryButton,
                            onPressed: () {/*
                              // Abrir BottomSheet
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // permite que suba al escribir en inputs
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return AddProductBottomSheet(orderId: order.orderId);
                                },
                              );*/
                            },
                            child: const Text("Pagar"),
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

    );
  }
}
