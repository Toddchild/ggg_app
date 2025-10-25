import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initForApp(AppFlavor.contractor);
  runApp(const ContractorApp());
}

class ContractorApp extends StatelessWidget {
  const ContractorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor App',
      theme: AppTheme.light(),
      home: const Scaffold(
        appBar: AppBar(title: Text('Contractor')),
        body: Center(child: Text('Contractor app using shared package')),
      ),
    );
  }
}
