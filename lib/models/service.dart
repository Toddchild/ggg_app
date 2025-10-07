// lib/models/service.dart
class Service {
  final String id;
  final String name;
  final int minutes;
  final double price;

  const Service({
    required this.id,
    required this.name,
    required this.minutes,
    required this.price,
  });
}
