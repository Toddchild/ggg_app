/// A single booking record.
class Booking {
  Booking({
    required this.id,
    required this.serviceName,
    required this.minutes,
    required this.price,
    required this.when,
  });

  final String id;
  final String serviceName;
  final int minutes;
  final double price;
  final DateTime when;
}

/// Very simple in-memory store for the current app session.
class BookingStore {
  final List<Booking> _items = [];

  List<Booking> get items => List.unmodifiable(_items);

  void add(Booking b) => _items.add(b);

  void clear() => _items.clear();
}

/// Global instance you can import anywhere.
final bookingStore = BookingStore();
