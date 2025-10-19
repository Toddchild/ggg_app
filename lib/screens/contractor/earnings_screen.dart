import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Earnings & Payout History',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }
}
