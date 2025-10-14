import 'package:flutter/material.dart';
import 'package:proyecto_uno/style/styles.dart';
import 'package:proyecto_uno/controllers/user_dao.dart';
import 'package:proyecto_uno/screens/loading_page.dart';
import 'package:proyecto_uno/utils/session_manager.dart';

final userDao = UserDao();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función para manejar el login
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _userController.text;
      final password = _passwordController.text;

      // Muestra un feedback al usuario mientras se verifica
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verificando credenciales...")),
      );

      // Llama a tu método en userDao. Este método debería verificar email y contraseña.
      final user = await userDao.loginUser(email, password);

      // Es una buena práctica verificar si el widget sigue "montado" (visible)
      // después de una operación asíncrona.
      if (!mounted) return;

      // Si el método loginUser devuelve un usuario, significa que el login fue exitoso.
      if (user != null) {
        // Guarda la sesión del usuario
        final ctx = context;
        await SessionManager.saveSession(user['user_id'] , user['email']);
        //Navigator.of(context).pop();
        //Navigator.pushNamed(context, AppRoutes.loading);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoadingPage())
        if (!ctx.mounted) return;
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
        );

      } else {
        // Si el usuario es nulo, las credenciales son incorrectas.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: AppColors.dangerColor,
              content: Text("Usuario o contraseña incorrectos.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                const Center(
                  child: Text(
                    "Realeza Químicos",
                    style: AppTextStyles.title,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Inicia sesión en tu cuenta",
                    style: AppTextStyles.subtitle,
                  ),
                ),
                const SizedBox(height: 40),

                // Campo Usuario
                TextFormField(
                  controller: _userController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Usuario",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El usuario es obligatorio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La contraseña es obligatoria";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: lógica de recuperar contraseña
                    },
                    child: const Text("¿Olvidaste tu contraseña?"),
                  ),
                ),

                const SizedBox(height: 40),

                // Botón iniciar sesión
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleLogin,
                  child: const Text(
                    "INICIAR SESIÓN",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta? "),
                    GestureDetector(
                      onTap: () {
                        // TODO: navegación a registro
                      },
                      child: const Text(
                        "Regístrate",
                        style: AppTextStyles.cursive,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
