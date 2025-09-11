import 'package:flutter/material.dart';

void main() => runApp(const CustomerApp());

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGG – Customer',
      home: Scaffold(
        appBar: AppBar(title: const Text('Customer App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // for now just show a snackbar until deep link is added
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contractor app coming soon...')),
              );
            },
            child: const Text('Would you like to become a contractor?'),
          ),
        ),
      ),
    );
  }
}
