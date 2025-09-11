import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../services/cred_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _busy = true; _error = null; });
    try {
      final auth = base64Encode(utf8.encode('${_userC.text}:${_passC.text}'));
      final uri = Uri.parse('${AppConfig.baseUrl}/wp-json/wp/v2/users/me');
      final res = await http.get(uri, headers: {
        'Authorization': 'Basic $auth',
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        await CredStore().save(_userC.text, _passC.text);
        if (!mounted) return;
        Navigator.pop(context, true); // success
      } else {
        setState(() => _error = 'Login failed (${res.statusCode}). Check username & Application Password.');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _userC, decoration: const InputDecoration(labelText: 'Username (e.g., contractor1)')),
            TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Application Password'), obscureText: true),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _login,
              child: _busy
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
