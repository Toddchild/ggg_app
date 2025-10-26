// lib/data/app_config.dart
import 'package:flutter/material.dart';

/// Defines a simple item for quick, one-tap checkout.
class QuickItem {
  final int productId;
  final String label;
  final IconData icon;

  const QuickItem({
    required this.productId,
    required this.label,
    required this.icon,
  });
}

/// Global application configuration settings.
class AppConfig {
  // Base URL for the external WooCommerce site or Quote Engine.
  static const String baseUrl = 'https://demo-garbage-app.com';

  // Quick items used for the CustomerOneTapScreen
  static const List<QuickItem> quickItems = [
    QuickItem(
      productId: 101, // Corresponds to a product ID in the external store
      label: 'Single Mattress',
      // Swapped from bed_outlined to single_bed_outlined for clarity
      icon: Icons.single_bed_outlined,
    ),
    QuickItem(
      productId: 102,
      label: 'Small Appliance',
      // Swapped from kitchen_outlined to local_laundry_service_outlined
      // to better represent a standalone appliance.
      icon: Icons.local_laundry_service_outlined,
    ),
    QuickItem(
      productId: 103,
      label: 'Small Furniture',
      // Swapped from chair_outlined to table_bar_outlined
      // for a more general 'furniture' look.
      icon: Icons.table_bar_outlined,
    ),
    QuickItem(
      productId: 104,
      label: 'Yard Waste Bag (x5)',
      // Swapped from grass_outlined to delete_sweep_outlined
      // to clearly indicate a cleanup/removal service.
      icon: Icons.delete_sweep_outlined,
    ),
  ];

  static Future<void> initForApp(param0) async {}
}
