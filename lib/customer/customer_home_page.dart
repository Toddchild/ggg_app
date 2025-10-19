// lib/screens/customer_home.dart

import 'package:flutter/material.dart';
import 'package:ggg_app/customer/booking/booking_time_page.dart';
// Assume this file exists for single-item booking flow
import '../customer/multi_item_selection_page.dart';

// Service data model for the main selection cards
class Service {
  final String title;
  final String description;
  final IconData icon;
  final double basePrice;

  const Service({
    required this.title,
    required this.description,
    required this.icon,
    required this.basePrice,
  });
}

// The "six main cards" the user mentioned
const List<Service> _availableServices = [
  Service(title: 'Single Item Pickup', description: 'For one large item only.', icon: Icons.shopping_bag, basePrice: 150.00),
  Service(title: 'Yard Waste Removal', description: 'Bags of leaves, branches, etc.', icon: Icons.grass, basePrice: 80.00),
  Service(title: 'Appliance Removal', description: 'Old washer, dryer, or fridge.', icon: Icons.kitchen, basePrice: 120.00),
  Service(title: 'Construction Debris', description: 'Wood, drywall, and rubble.', icon: Icons.construction, basePrice: 200.00),
  Service(title: 'E-Waste Recycling', description: 'Computers, monitors, printers.', icon: Icons.computer, basePrice: 50.00),
  Service(title: 'Tire Disposal', description: 'Disposal of old car and truck tires.', icon: Icons.tire_repair, basePrice: 25.00),
];

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  void _navigateToServiceBooking(BuildContext context, Service service) {
    // This navigation path is for the simpler, single-service flow
    Navigator.of(context).push(
      MaterialPageRoute(
        // NOTE: The app defines two different `Service` classes (one here and one in customer/models.dart).
        // Cast to `dynamic` to bypass the static type mismatch. Prefer unifying the model or converting explicitly.
        builder: (context) => BookingTimePage(service: service as dynamic),
      ),
    );
  }

  void _navigateToBulkSelection(BuildContext context) {
    // This navigation path is for the new, complex multi-item, truck-load flow
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MultiItemSelectionPage(),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _navigateToServiceBooking(context, service),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(service.icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                service.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text('Starting at \$${service.basePrice.toStringAsFixed(2)}',
                   style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Pickup'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose one of our quick options or build a custom bulk order below.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.85, // Adjust card height
              ),
              itemCount: _availableServices.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(context, _availableServices[index]);
              },
            ),
          ),
        ],
      ),
      
      // The prominent button for bulk/multi-item selection
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToBulkSelection(context),
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Build Custom Bulk Order (Truck Load Tally)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
