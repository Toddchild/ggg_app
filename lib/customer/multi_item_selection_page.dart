// lib/customer/multi_item_selection_page.dart

import 'package:flutter/material.dart';

// --- ITEM & TRUCK DATA MODELS & CONSTANTS ---

// Global configuration for truck load volume (used for metrics, no longer for pricing)
const int kTruckLoadCapacity = 10; // Items filling 10 units
const double kFullTruckPrice =
    400.00; // Fixed price for a full truckload (now informational)

// Environmental Fee Constants derived from the provided website logic
const double kEnvironmentalFeePerItem = 40.00;
const Set<String> kEnvironmentalFeeKeys = {
  'fridge',
  'refrigerator',
  'freezer',
  'chest freezer',
  'air conditioner',
  'air-conditioner',
  'airconditioner',
  'ac unit',
  'water cooler',
  'water-cooler',
  'watercooler'
};

// Defines an individual item with a cost, volume unit, and a unique key
class BulkItem {
  final String name;
  final String
      key; // Unique key for environmental fee matching (e.g., 'fridge')
  final double price; // Individual item price
  final int volumeUnit; // How much 'volume' this item takes up (1-10)

  const BulkItem({
    required this.name,
    required this.key,
    required this.price,
    required this.volumeUnit,
  });
}

// Sample data for the item picker (Keys added for fee matching)
const List<BulkItem> _availableItems = [
  BulkItem(name: 'Sofa (3-seater)', key: 'sofa', price: 90.00, volumeUnit: 4),
  BulkItem(name: 'Large Fridge', key: 'fridge', price: 120.00, volumeUnit: 3),
  BulkItem(
      name: 'Large Mattress',
      key: 'large-mattress',
      price: 65.00,
      volumeUnit: 3),
  BulkItem(
      name: 'Box of General Junk',
      key: 'junk-box',
      price: 20.00,
      volumeUnit: 1),
  BulkItem(
      name: 'TV (Large Flat Screen)', key: 'tv', price: 40.00, volumeUnit: 2),
  BulkItem(name: 'Tire (Car/Truck)', key: 'tire', price: 15.00, volumeUnit: 1),
  BulkItem(
      name: 'Recliner Chair', key: 'recliner', price: 50.00, volumeUnit: 2),
  BulkItem(name: 'Desk/Table', key: 'desk', price: 75.00, volumeUnit: 3),
  BulkItem(
      name: 'Chest Freezer',
      key: 'chest freezer',
      price: 150.00,
      volumeUnit: 3),
];

class MultiItemSelectionPage extends StatefulWidget {
  const MultiItemSelectionPage({super.key});

  @override
  State<MultiItemSelectionPage> createState() => _MultiItemSelectionPageState();
}

class _MultiItemSelectionPageState extends State<MultiItemSelectionPage> {
  // Map to store the quantity selected for each item
  final Map<BulkItem, int> _selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize all items with a quantity of 0
    for (final item in _availableItems) {
      _selectedQuantities[item] = 0;
    }
  }

  // --- CORE PRICING LOGIC (Item Cost + Environmental Fee) ---

  Map<String, dynamic> _calculateTotalCost() {
    int totalVolume = 0;
    double itemsTotal = 0.0;
    double envTotal = 0.0;

    _selectedQuantities.forEach((item, quantity) {
      if (quantity > 0) {
        // 1. Calculate item cost and volume
        totalVolume += item.volumeUnit * quantity;
        itemsTotal += item.price * quantity;

        // 2. Check for Environmental Fee (matching logic from your JS)
        // Normalize key by lowercasing and replacing hyphens with spaces for matching
        final normalizedKey = item.key.toLowerCase().replaceAll('-', ' ');
        if (kEnvironmentalFeeKeys.contains(normalizedKey)) {
          envTotal += kEnvironmentalFeePerItem * quantity;
        }
      }
    });

    // 3. The new final price logic: Grand Total = Item Costs + Environmental Fees
    final double finalPrice = itemsTotal + envTotal;

    // 4. Calculate volume metrics for informational display (retaining the truck tally logic)
    final int fullTrucks = totalVolume ~/ kTruckLoadCapacity;
    final int remainingVolume = totalVolume % kTruckLoadCapacity;

    return {
      'finalPrice': finalPrice,
      'itemsTotal': itemsTotal,
      'envTotal': envTotal,
      'totalVolume': totalVolume,
      'fullTrucks': fullTrucks,
      'remainingVolume': remainingVolume,
    };
  }

  void _updateQuantity(BulkItem item, int change) {
    setState(() {
      int newQuantity = (_selectedQuantities[item] ?? 0) + change;
      _selectedQuantities[item] =
          newQuantity.clamp(0, 99); // Clamp quantity between 0 and 99
    });
  }

  // --- WIDGET BUILDERS ---

  Widget _buildItemCard(BulkItem item) {
    final quantity = _selectedQuantities[item] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'Price: \$${item.price.toStringAsFixed(2)} | Volume: ${item.volumeUnit} units',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (kEnvironmentalFeeKeys
                      .contains(item.key.toLowerCase().replaceAll('-', ' ')))
                    Text(
                      '+\$${kEnvironmentalFeePerItem.toStringAsFixed(2)} Environmental Fee',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),

            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  onPressed:
                      quantity > 0 ? () => _updateQuantity(item, -1) : null,
                ),
                SizedBox(
                  width: 30,
                  child: Text('$quantity',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () => _updateQuantity(item, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateTotalCost();
    final finalPrice = results['finalPrice'] as double;
    final itemsTotal = results['itemsTotal'] as double;
    final envTotal = results['envTotal'] as double;
    final totalVolume = results['totalVolume'] as int;
    final fullTrucks = results['fullTrucks'] as int;

    final bool canContinue = totalVolume > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Item Selection'),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Select your items below. The total price is based on item cost and environmental fees.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Divider(height: 32),

                // List of items
                ..._availableItems.map(_buildItemCard),

                const SizedBox(height: 100), // Extra space for floating bar
              ],
            ),
          ),
        ],
      ),

      // Persistent Bottom Bar for Tally and Continue
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Volume Metrics (Informational Only) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Estimated Volume:',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('$totalVolume units ($fullTrucks full loads)',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 16),

              // --- Price Breakdown ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item Costs:',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('\$${itemsTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Environmental Fees:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.orange)),
                  Text('\$${envTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.orange)),
                ],
              ),
              const Divider(height: 24),

              // Total Price Tally
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '\$${finalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canContinue
                      ? () {
                          // TODO: Replace this with navigation to the next booking step (Time/Location)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Total Price: \$${finalPrice.toStringAsFixed(2)}. Proceeding to scheduling.')),
                          );
                        }
                      : null,
                  child: Text(canContinue
                      ? 'Continue with Selection'
                      : 'Select items to continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
