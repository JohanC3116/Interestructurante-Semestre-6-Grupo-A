import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final supabase = Supabase.instance.client;
  String? activityId;
  DateTime? loginTime;

  @override
  void initState() {
    super.initState();
    _registerLogin(); // registrar cuando entra
  }

  Future<void> _registerLogin() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    loginTime = DateTime.now();

    final response = await supabase.from('user_activity').insert({
      'user_id': user.id,
      'login_time': loginTime!.toIso8601String(),
    }).select('id').single();

    setState(() {
      activityId = response['id'].toString();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final user = supabase.auth.currentUser;
    if (user != null && activityId != null && loginTime != null) {
      final logoutTime = DateTime.now();
      final duration = logoutTime.difference(loginTime!);

      await supabase.from('user_activity').update({
        'logout_time': logoutTime.toIso8601String(),
        'duration': duration.inSeconds,
      }).eq('id', activityId!);
    }

    await supabase.auth.signOut();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Success")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "✅ Login Successful!",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Cerrar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
