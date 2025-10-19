import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My Active Routes & Map',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }
}
