import 'package:flutter/material.dart';

class ContractorOnboardingScreen extends StatelessWidget {
  const ContractorOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Onboarding')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Welcome! Let’s confirm you can do the work.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Text('You will need:'),
          SizedBox(height: 8),
          Text('• A pickup/van/truck\n• Basic tools (dolly, blankets, straps, boots)\n• Ability to lift and handle stairs'),
          SizedBox(height: 24),
          Text('We’ll collect photos of your vehicle, your basic details, and your availability.'),
        ],
      ),
    );
  }
}
