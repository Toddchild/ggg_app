// lib/models.dart
import 'package:flutter/foundation.dart';

@immutable
class Service {
  final String? id;
  final String name;
  final String description; // non-null, allow empty string
  final int minutes;
  final double price;
  final String? imageUrl; // nullable

  const Service({
    this.id,
    required this.name,
    this.description = '',
    required this.minutes,
    required this.price,
    this.imageUrl,
  });
}

/// Demo data (use id where available)
const List<Service> demoServices = [
  Service(
    id: 'svc_haircut',
    name: 'Haircut',
    description: 'Classic haircut with wash and style.',
    minutes: 45,
    price: 35.00,
    imageUrl: 'https://picsum.photos/seed/haircut/800/450',
  ),
  Service(
    id: 'svc_beard',
    name: 'Beard Trim',
    description: 'Detailed beard shaping and trim.',
    minutes: 20,
    price: 15.00,
    imageUrl: 'https://picsum.photos/seed/beard/800/450',
  ),
  Service(
    id: 'svc_color',
    name: 'Color',
    description: 'Single-process color. Consultation included.',
    minutes: 90,
    price: 85.00,
    imageUrl: null,
  ),
];
