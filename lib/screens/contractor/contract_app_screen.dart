import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Contractor Dashboard Screen\n(Next Available Routes)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
      ),
    );
  }
}
