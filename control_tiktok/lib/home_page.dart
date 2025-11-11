import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _registrarActividad();
  }

  /// 📝 Guardar login en la tabla user_activity
  Future<void> _registrarActividad() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('user_activity').insert({
        'user_id': user.id,
        'login_time': DateTime.now().toIso8601String(),
        'logout_time': null,
        'duration': null,
      });

      print("✅ Actividad guardada en Supabase");
    } catch (e) {
      print("❌ Error guardando actividad: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Successful",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }
}
