import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 👇 Importamos el historial
import 'historial_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final supabase = Supabase.instance.client;

  // ⚠️ Solo para desarrollo, no dejar visible en producción
  final String serviceRoleKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50dmxqYmxsYm9jcXFqYnB3ZWFxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODc1ODQ1NywiZXhwIjoyMDc0MzM0NDU3fQ.z-2rgjvQ4hgRIO1UBS4lctc0VizrfwCDxDwY4OURRPU";
  final String supabaseUrl = "https://ntvljbllbocqqjbpweaq.supabase.co";

  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAuthUsers();
  }

  /// 🔄 Cargar usuarios desde auth.users
  Future<void> loadAuthUsers() async {
    setState(() => loading = true);

    final url = Uri.parse('$supabaseUrl/auth/v1/admin/users');

    try {
      final response = await http.get(
        url,
        headers: {
          'apikey': serviceRoleKey,
          'Authorization': 'Bearer $serviceRoleKey',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = (decoded is Map && decoded['users'] != null)
            ? decoded['users']
            : (decoded is List ? decoded : []);

        setState(() {
          users = data;
          loading = false;
        });
      } else {
        print('Error al cargar usuarios: ${response.statusCode}');
        print('Body: ${response.body}');
        setState(() => loading = false);
      }
    } catch (e) {
      print('Exception loadAuthUsers: $e');
      setState(() => loading = false);
    }
  }

  /// ➕ Crear usuario en auth.users
  Future<void> createAuthUser(String email, String password) async {
    final url = Uri.parse('$supabaseUrl/auth/v1/admin/users');

    try {
      final response = await http.post(
        url,
        headers: {
          'apikey': serviceRoleKey,
          'Authorization': 'Bearer $serviceRoleKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'email_confirm': true,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Usuario creado correctamente')),
        );
        loadAuthUsers();
      } else {
        print('Error createAuthUser ${response.statusCode} -> ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      print('Exception createAuthUser: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// 🧩 Mostrar diálogo de creación
  void showCreateUserDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar nuevo usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Registrar'),
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todos los campos son obligatorios')),
                );
                return;
              }

              Navigator.pop(context);
              createAuthUser(email, password);
            },
          ),
        ],
      ),
    );
  }

  /// ✏️ Editar usuario (email, nombre, contraseña)
  Future<void> editUser(String userId, String currentEmail, String currentName) async {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre (opcional)'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña (dejar en blanco = sin cambio)',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nota: si dejas contraseña en blanco, no se actualizará.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () async {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();
                final newPassword = passwordController.text;

                final Map<String, dynamic> body = {};

                if (newEmail.isNotEmpty && newEmail != currentEmail) {
                  body['email'] = newEmail;
                }
                if (newPassword.isNotEmpty) {
                  body['password'] = newPassword;
                }
                if (newName.isNotEmpty && newName != currentName) {
                  body['user_metadata'] = {'full_name': newName};
                }

                if (body.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No se realizaron cambios')),
                  );
                  return;
                }

                final url = Uri.parse('$supabaseUrl/auth/v1/admin/users/$userId');

                try {
                  final response = await http.put(
                    url,
                    headers: {
                      'apikey': serviceRoleKey,
                      'Authorization': 'Bearer $serviceRoleKey',
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(body),
                  );

                  print('PUT ${response.statusCode} -> ${response.body}');

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Usuario actualizado correctamente')),
                    );
                    Navigator.pop(context);
                    await loadAuthUsers();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar: ${response.body}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// 🗑️ Confirmar y eliminar usuario
  Future<void> confirmAndDelete(String userId, String email) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar usuario $email? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await deleteUser(userId);
    }
  }

  /// 🚫 Eliminar usuario desde auth.users
  Future<void> deleteUser(String userId) async {
    final url = Uri.parse('$supabaseUrl/auth/v1/admin/users/$userId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'apikey': serviceRoleKey,
          'Authorization': 'Bearer $serviceRoleKey',
        },
      );

      // ✅ Algunos servidores devuelven 200 con body vacío
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Usuario eliminado correctamente')),
        );
        loadAuthUsers();
      } else {
        print('Error deleteUser ${response.statusCode} -> ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: ${response.body}')),
        );
      }
    } catch (e) {
      print('Exception deleteUser: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// 🚪 Cerrar sesión
  Future<void> signOut() async {
    await supabase.auth.signOut();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadAuthUsers),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Ver historial de actividad",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistorialPage()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: signOut),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No hay usuarios registrados"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index] as Map<String, dynamic>;
                    final email = user['email'] ?? 'Sin correo';
                    final id = user['id'] ?? 'Sin ID';
                    final createdAt = user['created_at'] ?? 'Sin fecha';

                    String name = '';
                    try {
                      final meta = user['user_metadata'];
                      if (meta != null && meta is Map) {
                        name = (meta['full_name'] ?? meta['name'] ?? '').toString();
                      }
                    } catch (_) {
                      name = '';
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(email),
                        subtitle: Text(
                          'ID: $id\nNombre: ${name.isEmpty ? "—" : name}\nRegistrado: $createdAt',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editUser(id.toString(), email.toString(), name),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmAndDelete(id.toString(), email.toString()),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateUserDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
