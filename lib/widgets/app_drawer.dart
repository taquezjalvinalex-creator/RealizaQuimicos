import 'package:flutter/material.dart';
import '../style/styles.dart'; // importa tus estilos
import 'package:proyecto_uno/routes/app_routes.dart'; //rutas
import 'package:proyecto_uno/utils/session_manager.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar el email del usuario USANDO TU SessionManager
  Future<void> _loadUserData() async {
    // Usamos el método getUsername de SessionManager
    final String? email = await SessionManager.getUsername(); // USA SESSION MANAGER
    if (mounted) { // Buena práctica: verificar si el widget sigue montado
      setState(() {
        _userEmail = email;
      });
    }
  }

  void _navigateToUserPage(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/user');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              accountName: GestureDetector(
                onTap: () {
                  if (_userEmail != null) {
                    _navigateToUserPage(context);
                  }
                },
                child: Text(
                  _userEmail ?? "Cargando...", // Muestra el email o "Cargando..."
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),
              ),
              accountEmail: null,
              currentAccountPicture: GestureDetector(
                onTap: () {
                  if (_userEmail != null) {
                    _navigateToUserPage(context);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _userEmail?.isNotEmpty == true ? _userEmail![0].toUpperCase() : "U",
                    style: TextStyle(fontSize: 40.0, color: AppColors.primary),
                  ),
                ),
              ),
              otherAccountsPictures: [
                if (_userEmail != null)
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white70),
                    onPressed: () => _navigateToUserPage(context),
                    tooltip: 'Ir al perfil',
                  )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text("Inicio", style: AppTextStyles.subtitle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.routes);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: AppColors.primary),
              title: const Text("Clientes", style: AppTextStyles.subtitle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.clients,arguments: 0,); //Pasamos el argumento 0 para obtener todos los clientes
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: AppColors.primary),
              title: const Text("Productos", style: AppTextStyles.subtitle),
              onTap: () {
                /*
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.clients);*/
              },
            ),
            ListTile(
              leading: const Icon(Icons.delivery_dining, color: AppColors.primary),
              title: const Text("Pedidos", style: AppTextStyles.subtitle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.orders,arguments: 0,);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primary),
              title: const Text("Configuración", style: AppTextStyles.subtitle),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppColors.dangerColor),
              title: const Text("Cerrar sesión", style: AppTextStyles.subtitle),
              onTap: () async { // Marcar como async para usar await SessionManager.logout()
                final ctx = context;
                await SessionManager.logout(); // USA TU SESSION MANAGER PARA CERRAR SESIÓN
                if (!ctx.mounted) return; // 🔹 Verifica si sigue montado
                Navigator.of(ctx).popUntil((route) => route.isFirst);
                Navigator.pushReplacementNamed(ctx, AppRoutes.login);
                /*
                if (mounted) { // Verificar si el widget está montado antes de navegar
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }*/
              },
            ),
          ],
        ),
      ),
    );
  }
}
