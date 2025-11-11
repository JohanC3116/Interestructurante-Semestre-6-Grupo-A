import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportePage extends StatefulWidget {
  final String userId;

  const ReportePage({super.key, required this.userId});

  @override
  State<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  List<Map<String, dynamic>> _reportes = [];

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    try {
      final response = await Supabase.instance.client
          .from('uso_tiempo') // 👈 nombre de tu tabla en Supabase
          .select()
          .eq('user_id', widget.userId); // filtrar solo el usuario actual

      setState(() {
        _reportes = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint("Error cargando reportes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reportes de uso")),
      body: _reportes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Tiempo en app (min)")),
                  DataColumn(label: Text("Inicio")),
                  DataColumn(label: Text("Fin")),
                ],
                rows: _reportes.map((r) {
                  return DataRow(cells: [
                    DataCell(Text(r['id'].toString())),
                    DataCell(Text(r['tiempo_minutos']?.toString() ?? '0')),
                    DataCell(Text(r['inicio']?.toString() ?? '')),
                    DataCell(Text(r['fin']?.toString() ?? '')),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
