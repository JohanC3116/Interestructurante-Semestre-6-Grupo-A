import 'package:flutter/material.dart';
import 'admin_panel.dart';
import 'login_page.dart'; // Tu pantalla de login del usuario
import 'admin_login.dart'; // 👈 nuevo import correcto

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Rol"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "¿Cómo deseas ingresar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // 🔹 Botón para usuario normal
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text("Ingresar como Usuario"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Botón para admin
              ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Ingresar como Administrador"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  // ✅ Corregido: el widget correcto es AdminLoginPage()
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
