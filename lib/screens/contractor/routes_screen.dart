import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  static const List<_RouteStop> _stops = [
    _RouteStop(
      address: '125 Main St',
      city: 'Anytown',
      wasteType: 'Furniture',
      payout: 85.0,
      isCompleted: false,
    ),
    _RouteStop(
      address: '89 Oak Ave',
      city: 'Anytown',
      wasteType: 'Yard Debris',
      payout: 120.0,
      isCompleted: true,
    ),
    _RouteStop(
      address: '44 Pine Rd',
      city: 'Anytown',
      wasteType: 'Construction',
      payout: 140.0,
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'My Active Routes & Map',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _stops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final stop = _stops[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    stop.isCompleted
                        ? Icons.check_circle
                        : Icons.local_shipping_outlined,
                    color: stop.isCompleted ? Colors.green : Colors.blueGrey,
                  ),
                  title: Text('${stop.address}, ${stop.city}'),
                  subtitle: Text('${stop.wasteType} • \$${stop.payout.toStringAsFixed(0)}'),
                  trailing: Chip(
                    label: Text(stop.isCompleted ? 'Done' : 'Pending'),
                    backgroundColor:
                        stop.isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RouteStop {
  final String address;
  final String city;
  final String wasteType;
  final double payout;
  final bool isCompleted;

  const _RouteStop({
    required this.address,
    required this.city,
    required this.wasteType,
    required this.payout,
    required this.isCompleted,
  });
}
