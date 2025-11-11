import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'role_selection.dart';
import 'admin_panel.dart'; // Import del panel de administrador

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase antes de correr la app
  await Supabase.initialize(
    url: "https://ntvljbllbocqqjbpweaq.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50dmxqYmxsYm9jcXFqYnB3ZWFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3NTg0NTcsImV4cCI6MjA3NDMzNDQ1N30.lOBOnRyAXu5xHCMFnVX53YYbEDLnvx0XjT4ICRRUvYQ",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Tik Tok Control',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const RoleSelectionScreen(), // Pantalla inicial
      routes: {
        '/admin': (context) => const AdminPanel(), // Ruta para admin
      },
    );
  }
}
