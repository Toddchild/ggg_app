import 'package:flutter/material.dart';

class RequestPickupScreen extends StatelessWidget {
  const RequestPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pickup Request'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_shopping_cart, size: 60, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Pickup Request Form Goes Here',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Input fields for type of waste, quantity, and date.'),
          ],
        ),
      ),
    );
  }
}
