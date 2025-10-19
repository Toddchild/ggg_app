import 'package:flutter/material.dart';
import 'contractor_app.dart';

void main() {
  // Ensure Flutter is initialized before running the app.
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
        // Using a professional, contractor-focused color scheme (Orange/Amber).
        colorSchemeSeed: Colors.amber,
      ),
      // The Contractor App starts here. (It will show the existing content of contractor_app.dart)
      home: const ContractorApp(),
    );
  }
}
