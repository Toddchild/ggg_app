import 'package:flutter/foundation.dart';

@immutable
class Service {
  final String name;
  final String description;   // keep non-null, allow empty string
  final int minutes;
  final double price;
  final String? imageUrl;     // nullable

  const Service({
    required this.name,
    this.description = '',
    required this.minutes,
    required this.price,
    this.imageUrl,
  });
}

/// Demo data
const List<Service> demoServices = [
  Service(
    name: 'Haircut',
    description: 'Classic haircut with wash and style.',
    minutes: 45,
    price: 35.00,
    imageUrl: 'https://picsum.photos/seed/haircut/800/450',
  ),
  Service(
    name: 'Beard Trim',
    description: 'Detailed beard shaping and trim.',
    minutes: 20,
    price: 15.00,
    imageUrl: 'https://picsum.photos/seed/beard/800/450',
  ),
  Service(
    name: 'Color',
    description: 'Single-process color. Consultation included.',
    minutes: 90,
    price: 85.00,
    imageUrl: null, // intentionally no image
  ),
];
