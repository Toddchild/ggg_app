// lib/models/pickup_item.dart

import 'package:flutter/foundation.dart';

@immutable
class PickupItem {
  final int id;
  final String name;
  final String description;
  final double basePrice;
  final String? imageUrl; // Placeholder image URL for the item

  const PickupItem({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.imageUrl,
    int? quantity,
  });

  int? get quantity => null;
}

// Updated demo list of items reflecting Go Garbage Grabber service categories.
// IMPORTANT: Replace the 'basePrice' values below with your actual pricing
// from gogarbagegrabber.com before deploying!
const List<PickupItem> demoPickupItems = [
  PickupItem(
    id: 101,
    name: 'Household Bag (Standard)',
    description: 'One standard residential garbage bag (30-40L).',
    basePrice: 5.50, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/A3C7FD/035AE4?text=Bag',
  ),
  PickupItem(
    id: 102,
    name: 'Mattress (Single/Double)',
    description: 'Any mattress or box spring up to double size.',
    basePrice: 70.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/FDC1A3/E45A03?text=Mattress',
  ),
  PickupItem(
    id: 103,
    name: 'Sofa/Couch (3-Seater)',
    description: 'Standard three-seater sofa, loveseat, or sectional piece.',
    basePrice: 80.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/D4A3FD/5703E4?text=Couch',
  ),
  PickupItem(
    id: 104,
    name: 'Major Appliance',
    description: 'Fridge, stove, washing machine, or dryer.',
    basePrice: 95.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/C5FDA3/269302?text=Appliance',
  ),
  PickupItem(
    id: 105,
    name: 'Small E-Waste/TV',
    description: 'Computer monitor, small TV (under 32"), or electronics box.',
    basePrice: 20.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/FDCDA3/E45A03?text=E-Waste',
  ),
  PickupItem(
    id: 106,
    name: 'Car Tire (No Rim)',
    description: 'Standard vehicle tire with the rim removed.',
    basePrice: 15.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/A3FDFD/03C7E4?text=Tire',
  ),
  PickupItem(
    id: 107,
    name: 'Yard Waste (Large Bag)',
    description: 'Oversize bag (90L) of leaves, clippings, or light debris.',
    basePrice: 10.00, // INSERT YOUR PRICE HERE
    imageUrl: 'https://placehold.co/100x100/FDD8A3/E48D03?text=Yard',
  ),
];
