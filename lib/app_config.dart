// lib/app_config.dart
import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/widgets/icon_data.dart';

class AppConfig {
  static const String baseUrl = 'https://gogarbagegrabber.com/wp-json/ggg/v1';
  static const String defaultCity = 'red-deer';

  // TEMP: contractor creds for testing (use your real values)
  static const String contractorUsername = 'contractor1';
  static const String contractorAppPassword = 'E6JJ 1QMf MI67 VFSD PM3N BFgc';
  // (Used by the customer one-tap screen, OK to leave as-is or edit)
  static const quickItems = <QuickItem>[
    QuickItem(label: 'Couch', productId: 1234),
    QuickItem(label: 'Fridge', productId: 1260),
    QuickItem(label: 'Large Mattress', productId: 1239),
    QuickItem(label: 'Half Truck', productId: 1277),
    QuickItem(label: 'Full Truck', productId: 1278),
  ];

  static Color? get primaryBrandColor => null;

  static get navyBlue => null;

  static Color? get brandGreen => null;

  static String? get logoUrl => null;

  static Color? get lightBackground => null;
}

// tiny helper for the customer screen
class QuickItem {
  final String label;
  final int productId;
  final int quantity;
  const QuickItem({required this.label, required this.productId, this.quantity = 1});

  IconData? get icon => null;
}

 

