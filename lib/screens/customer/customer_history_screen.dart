import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Customer History Screen\n(Past and Pending Pickups)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
      ),
    );
  }
}
