import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> historial = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistorial();
  }

  /// 🔄 Cargar registros reales desde la tabla user_activity
  Future<void> loadHistorial() async {
    setState(() => loading = true);

    try {
      final response = await supabase
          .from('user_activity')
          .select('id, user_id, login_time, logout_time, duration')
          .order('login_time', ascending: false);

      setState(() {
        historial = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (e) {
      print("❌ Error cargando historial: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Uso"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadHistorial,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : historial.isEmpty
              ? const Center(child: Text("No hay registros de actividad"))
              : ListView.builder(
                  itemCount: historial.length,
                  itemBuilder: (context, index) {
                    final item = historial[index];
                    final userId = item['user_id'] ?? "—";
                    final login = item['login_time'] ?? "—";
                    final logout = item['logout_time'] ?? "—";
                    final duration = item['duration'] ?? "—";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text("Usuario: $userId"),
                        subtitle: Text(
                          "Inicio: $login\n"
                          "Salida: $logout\n"
                          "Duración: $duration",
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
