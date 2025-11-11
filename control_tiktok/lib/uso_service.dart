import 'package:supabase_flutter/supabase_flutter.dart';

class UsoService {
  final supabase = Supabase.instance.client;

  /// Registrar inicio de sesión de uso
  Future<void> iniciarSesionUso(String userId) async {
    await supabase.from('uso_tiempo').insert({
      'user_id': userId,
      'inicio': DateTime.now().toIso8601String(),
      'fin': null,
      'duracion_segundos': null,
    });
  }

  /// Registrar cierre de sesión de uso
  Future<void> cerrarSesionUso(String userId) async {
    final sesiones = await supabase
        .from('uso_tiempo')
        .select()
        .eq('user_id', userId)
        .isFilter('fin', null) // buscar la última sesión abierta
        .limit(1);

    if (sesiones.isNotEmpty) {
      final sesion = sesiones.first;
      final id = sesion['id'];
      final inicio = DateTime.parse(sesion['inicio']);
      final fin = DateTime.now();

      final duracion = fin.difference(inicio).inSeconds;

      await supabase.from('uso_tiempo').update({
        'fin': fin.toIso8601String(),
        'duracion_segundos': duracion,
      }).eq('id', id);
    }
  }

  /// Consultar historial de uso de un usuario
  Future<List<Map<String, dynamic>>> obtenerHistorial(String userId) async {
    final data = await supabase
        .from('uso_tiempo')
        .select()
        .eq('user_id', userId)
        .order('inicio', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }
}
