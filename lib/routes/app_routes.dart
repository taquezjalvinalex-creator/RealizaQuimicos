import 'package:flutter/material.dart';
import 'package:proyecto_uno/screens/login_page.dart';
import 'package:proyecto_uno/screens/loading_page.dart';
import 'package:proyecto_uno/screens/routes_page.dart';
import 'package:proyecto_uno/screens/client_page.dart';
import 'package:proyecto_uno/screens/client_detail_page.dart';
import 'package:proyecto_uno/screens/order_page.dart';
import 'package:proyecto_uno/screens/user_page.dart';
import '../models/product_model.dart';
import '../screens/client_form_page.dart';
import '../screens/payment_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String loading = '/loading';
  static const String routes = '/routes';
  static const String clients = '/clients';
  static const String clientDetail = '/clientDetail';
  static const String clientForm = '/clientForm';
  static const String payment = '/payment';
  static const String orders = '/orders';
  static const String user = '/user';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingPage());

      case routes:
        return MaterialPageRoute(builder: (_) => const RoutesPage());

      case clients:
        final arguments = settings.arguments;
        final routeId = arguments as int;
        return MaterialPageRoute(builder: (_) => ClientPage(routeId:routeId));

      case clientDetail:
        final arguments = settings.arguments;
        final clientId = arguments as int;
        return MaterialPageRoute(builder: (_) => ClientDetailPage(clientId:clientId));

      case clientForm:
        final arguments = settings.arguments;
        //final client = arguments as ClientModel?;
        final routeId = arguments as int?;
        return MaterialPageRoute(builder: (_) => ClientFormPage(routeId: routeId,));

      case payment:
        // 1. Obtiene los argumentos y trátalos como un Map.
        final arguments = settings.arguments as Map<String, dynamic>;
        // 2. Extrae cada valor del mapa usando su clave correspondiente.
        final clientId = arguments['clientId'] as int;
        final clientName = arguments['clientName'] as String;
        final quantities = arguments['quantities'] as Map<int, int>;
        final selectedProducts = arguments['selectedProducts'] as List<ProductModel>;

        return MaterialPageRoute(builder: (_) => PaymentPage(
            clientId:clientId,
            clientName: clientName,
            quantities:quantities,
            selectedProducts:selectedProducts
        ));


      case orders:
        final arguments = settings.arguments;
        final routeId = arguments as int;
        return MaterialPageRoute(builder: (_) => OrderPage(routeId:routeId));

      case user:
        return MaterialPageRoute(builder: (_) => const UserPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}