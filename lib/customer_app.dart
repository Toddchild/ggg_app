import 'package:flutter/material.dart';

// --- New Contractor Promotion Banner Widget ---

// ignore: unused_element
class _ContractorPromoBanner extends StatelessWidget {
  const _ContractorPromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade50, // Soft background for contrast
        border: Border(
          top: BorderSide(color: Colors.green.shade200, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping,
            color: Colors.green,
            size: 30,
          ),
          const SizedBox(width: 10),
          // Using an Expanded widget allows the text to wrap if necessary
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Drive for Garbage Grabber!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Earn money picking up junk on your own schedule.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // The action button
          OutlinedButton(
            onPressed: () {
              // TODO: Implement navigation to a sign-up flow later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Contractor sign-up link clicked!')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Apply Now',
                style: TextStyle(color: Colors.green, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// --- Main Customer App with Navigation and Banner ---

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Customer App')),
        body: const Center(child: Text('Customer app placeholder')),
      ),
    );
  }
}
