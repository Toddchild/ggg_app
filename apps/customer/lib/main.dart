import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initForApp(AppFlavor.customer);
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer App',
      theme: AppTheme.light(),
      home: const Scaffold(
        appBar: AppBar(title: Text('Customer')), 
        body: Center(child: Text('Customer app using shared package')),
      ),
    );
  }
}