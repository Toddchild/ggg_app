// lib/app_config.dart
import 'package:flutter/material.dart';

class AppConfig {
  static const String baseUrl = 'https://gogarbagegrabber.com/wp-json/ggg/v1';
  static const String defaultCity = 'red-deer';

  // TEMP: contractor creds for testing (do NOT commit real secrets)
  static const String contractorUsername = 'contractor1';
  static const String contractorAppPassword = 'REDACTED';

  // Location & stair fees (values in cents)
  static const int curbFeeCents = 0;
  static const int garageFeeCents = 1000; // $10.00
  static const int insideFeeCents = 2500; // $25.00
  static const int stairFeeCents = 50; // $0.50 per stair -> 50 cents

  // UI colors
  static Color get primaryBrandColor => const Color(0xFF0B6E4F);
  static Color get navyBlue => const Color(0xFF0F1724);
  static Color get brandGreen => const Color(0xFF2E8B57);
  static Color get lightBackground => const Color(0xFFF6FBF8);

  static String? get logoUrl => null;

  // Quick items (for one-tap tokens). priceCents and truckFraction added for later calculations.
  static const List<QuickItem> quickItems = <QuickItem>[
    QuickItem(label: 'Couch', productId: 1234, priceCents: 4500, truckFraction: 0.25),
    QuickItem(label: 'Fridge', productId: 1260, priceCents: 6000, truckFraction: 0.30),
    QuickItem(label: 'Large Mattress', productId: 1239, priceCents: 5500, truckFraction: 0.25),
    QuickItem(label: 'Half Truck', productId: 1277, priceCents: 25000, truckFraction: 0.50),
    QuickItem(label: 'Full Truck', productId: 1278, priceCents: 45000, truckFraction: 1.00),
    QuickItem(label: 'Small Appliance', productId: 1280, priceCents: 2000, truckFraction: 0.10),
  ];
}

class QuickItem {
  final String label;
  final int productId;
  final int priceCents;
  final double truckFraction;
  final int quantity;
  const QuickItem({
    required this.label,
    required this.productId,
    required this.priceCents,
    required this.truckFraction,
    this.quantity = 1,
  });

  IconData get icon {
    final key = label.toLowerCase();
    if (key.contains('couch')) return Icons.airline_seat_recline_extra;
    if (key.contains('fridge') || key.contains('appliance')) return Icons.kitchen;
    if (key.contains('mattress') || key.contains('bed')) return Icons.bed;
    if (key.contains('truck')) return Icons.local_shipping;
    if (key.contains('tire')) return Icons.tire_repair;
    return Icons.delete_outline;
  }

  String get priceDisplay => '\$${(priceCents / 100).toStringAsFixed(2)}';
}
