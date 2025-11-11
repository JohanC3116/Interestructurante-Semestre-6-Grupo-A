import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_panel.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool cargando = false;

  Future<void> iniciarSesionAdministrador() async {
    setState(() => cargando = true);

    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text.trim();

    try {
      // 🔍 Consulta en la tabla "usuario"
      final response = await supabase
          .from('usuario')
          .select()
          .eq('correo', correo)
          .eq('contrasena', contrasena)
          .maybeSingle();

      if (response == null) {
        mostrarError("Correo o contraseña incorrectos.");
      } else if (response['rol'] != 'admin') {
        mostrarError("No tienes permisos de administrador.");
      } else {
        // ✅ Éxito → ir al panel de admin
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPanel()),
          );
        }
      }
    } catch (e) {
      mostrarError("Error al iniciar sesión: $e");
    } finally {
      setState(() => cargando = false);
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Inicio de sesión del Administrador",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: correoController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: cargando ? null : iniciarSesionAdministrador,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Iniciar sesión",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
