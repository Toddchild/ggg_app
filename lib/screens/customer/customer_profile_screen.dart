import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Customer Profile Screen\n(Settings and Account)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
      ),
    );
  }
}
