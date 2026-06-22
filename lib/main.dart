import 'package:flutter/material.dart';
import 'contractor_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContractorMainApp());
}

class ContractorMainApp extends StatelessWidget {
  const ContractorMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garbage Guys - Contractor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
      ),
      home: const ContractorApp(),
    );
  }
}
