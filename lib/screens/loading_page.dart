import 'package:flutter/material.dart';
import 'dart:async'; // Para el Timer
import 'package:proyecto_uno/routes/app_routes.dart'; // Para tus rutas nombradas
import 'package:proyecto_uno/controllers/credit_dao.dart'; // Para tus rutas nombradas
import 'package:proyecto_uno/style/styles.dart'; // Para tus estilos

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    // QUI SE CARGAN CONFIGURACIONES Y DATOS INICIALES

    final creditController = CreditDao();
    await creditController.applySurchargesIfNeeded();

    Timer(const Duration(seconds: 2), () {
      // Asegúrate de que el widget todavía está montado antes de navegar
      if (mounted) {
        // Navega a la pantalla de rutas usando la ruta nombrada o directa
        Navigator.pushReplacementNamed(context, AppRoutes.routes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // O el color de fondo que prefieras
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Image.asset(
              'lib/static/app_img/logo_slogan.png', // Ruta a tu logo
              width: 200, // Ajusta el tamaño según sea necesario
              // También puedes agregar height si es necesario
            ),
            const SizedBox(height: 40),

            // Barra de progreso
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 20),

            // Texto opcional
            Text(
              'Cargando...',
              style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}