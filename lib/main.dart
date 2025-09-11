import 'package:flutter/material.dart';
import 'screens/customer_one_tap.dart';
import 'screens/contractor_home.dart';

void main() => runApp(const GGGApp());

class GGGApp extends StatelessWidget {
  const GGGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Garbage Grabber',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2dd4bf)),
        useMaterial3: true,
      ),
      home: const RoleSelectScreen(),
    );
  }
}

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Garbage Grabber')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Who are you using the app as?', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CustomerOneTapScreen()));
              },
              child: const Text('I’m a Customer'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContractorHome()));
              },
              child: const Text('I’m a Contractor'),
            ),
          ],
        ),
      ),
    );
  }
}


