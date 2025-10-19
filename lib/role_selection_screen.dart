import 'package:flutter/material.dart';

import 'customer_app.dart';
import 'contractor_app.dart';

/// The screen presented on launch that lets the user choose to run either
/// the Customer or Contractor application path.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garbage Guys - Select Your Role'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // App Logo Placeholder/Header
              const Icon(
                Icons
                    .local_shipping, // A general icon for transportation/service
                size: 80,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to the Garbage Guys Ecosystem',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
              ),
              const SizedBox(height: 48),

              // --- Customer Button ---
              RoleSelectionCard(
                title: 'Customer',
                subtitle:
                    'Request pickups, view schedule, and manage subscriptions.',
                icon: Icons.home_rounded,
                color: Colors.green.shade700,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CustomerApp(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- Contractor Button ---
              RoleSelectionCard(
                title: 'Contractor / Driver',
                subtitle:
                    'Manage routes, update pickup status, and complete daily tasks.',
                icon: Icons.assignment,
                color: Colors.amber.shade700,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ContractorApp(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable widget for the role selection buttons.
class RoleSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
