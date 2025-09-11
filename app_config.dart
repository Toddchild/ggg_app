class AppConfig {
  // Your live site
  static const String baseUrl = 'https://gogarbagegrabber.com';

  // Map visible item names -> WooCommerce product IDs
  // TODO: swap these demo IDs for your actual product IDs from WooCommerce
  static const quickItems = <QuickItem>[
    QuickItem(label: 'Couch',         productId: 101),
    QuickItem(label: 'Fridge',        productId: 102),
    QuickItem(label: 'Large Mattress',productId: 103),
    QuickItem(label: 'Half Truck',    productId: 201),
    QuickItem(label: 'Full Truck',    productId: 202),
  ];
}

class QuickItem {
  final String label;
  final int productId;
  const QuickItem({required this.label, required this.productId});
}
