import 'package:flutter/material.dart';
import 'service_list_page.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Customer App (Web) is running 🎉'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ServiceListPage()),
              ),
              child: const Text('Browse Services'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pushNamed('/book'),
              child: const Text('Go to Book (placeholder)'),
            ),
          ],
        ),
      ),
    );
  }
}
