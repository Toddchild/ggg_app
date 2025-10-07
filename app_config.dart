// lib/app_config.dart

class AppConfig {
  /// WordPress REST base for the GGG API (includes the namespace).
  static const String baseUrl =
      'https://gogarbagegrabber.com/wp-json/ggg/v1';

  /// Default city slug used in API queries.
  static const String defaultCity = 'red-deer';

  // TEMP: contractor creds for testing (use secure storage later)
  static const String contractorUsername = 'contractor1';
  static const String contractorAppPassword = 'E6JJ 1QMf MI67 VFSD PM3N BFgc';

  /// Map visible item names -> WooCommerce product IDs (demo IDs for now).
  static const quickItems = <QuickItem>[
    QuickItem(label: 'Couch',          productId: 1234),
    QuickItem(label: 'Fridge',         productId: 1260),
    QuickItem(label: 'Large Mattress', productId: 1239),
    QuickItem(label: 'Half Truck',     productId: 1277),
    QuickItem(label: 'Full Truck',     productId: 1278),
  ];
}

// tiny helper for the customer screen
class QuickItem {
  final String label;
  final int productId;
  final int quantity;
  const QuickItem({
    required this.label,
    required this.productId,
    this.quantity = 1,
  });
}
