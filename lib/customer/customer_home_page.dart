// lib/customer/customer_home_page.dart
//
// Customer home with six quick-service cards that use the canonical
// Service model (from lib/customer/models.dart) to avoid runtime type conflicts.

import 'package:flutter/material.dart';
import 'package:ggg_app/customer/booking/booking_time_page.dart';
import 'package:ggg_app/customer/multi_item_selection_page.dart';
import 'models.dart'; // canonical Service model for customer features

// Map service name (or id) to an icon for UI.
IconData _iconForService(Service s) {
  final key = s.name.toLowerCase();
  if (key.contains('couch') || key.contains('single') || key.contains('pickup')) {
    return Icons.airline_seat_recline_extra;
  } else if (key.contains('appliance') || key.contains('fridge') || key.contains('washer')) {
    return Icons.kitchen;
  } else if (key.contains('mattress')) {
    return Icons.bed;
  } else if (key.contains('truck') || key.contains('half') || key.contains('full')) {
    return Icons.local_shipping;
  } else if (key.contains('tire')) {
    return Icons.tire_repair;
  } else if (key.contains('ewaste') || key.contains('e-waste') || key.contains('elect')) {
    return Icons.computer;
  }
  return Icons.delete_outline;
}

// The "six main cards" the user wanted. Uses the canonical Service model.
final List<Service> _availableServices = [
  const Service(id: 'svc_single_item', name: 'Single Item Pickup', description: 'For one large item only.', minutes: 15, price: 150.00),
  const Service(id: 'svc_yard_waste', name: 'Yard Waste Removal', description: 'Bags of leaves, branches, etc.', minutes: 30, price: 80.00),
  const Service(id: 'svc_appliance', name: 'Appliance Removal', description: 'Old washer, dryer, or fridge.', minutes: 45, price: 120.00),
  const Service(id: 'svc_construction', name: 'Construction Debris', description: 'Wood, drywall, and rubble.', minutes: 60, price: 200.00),
  const Service(id: 'svc_ewaste', name: 'E-Waste Recycling', description: 'Computers, monitors, printers.', minutes: 20, price: 50.00),
  const Service(id: 'svc_tires', name: 'Tire Disposal', description: 'Disposal of old car and truck tires.', minutes: 10, price: 25.00),
];

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  void _navigateToServiceBooking(BuildContext context, Service service) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingTimePage(service: service),
      ),
    );
  }

  void _navigateToBulkSelection(BuildContext context) {
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
              Icon(_iconForService(service), size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                service.name,
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
              Text('Starting at \$${service.price.toStringAsFixed(2)}',
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
                childAspectRatio: 0.85,
              ),
              itemCount: _availableServices.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(context, _availableServices[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6),
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
