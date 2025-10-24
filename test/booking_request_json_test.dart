import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ggg_app/models/booking_request.dart';
import 'package:ggg_app/models/pickup_item.dart';
import 'package:ggg_app/services/api_service.dart';

void main() {
  test(
      'bookingRequestToJson produces expected keys and values (with PickupItem)',
      () {
    // Construct a real PickupItem instance using your actual constructor.
    final item = const PickupItem(
      id: 101,
      name: 'Household Bag (Standard)',
      description: 'One standard residential garbage bag (30-40L).',
      basePrice: 5.50,
      imageUrl: 'https://placehold.co/100x100/A3C7FD/035AE4?text=Bag',
    );

    final booking = BookingRequest(
      address: '123 Example St',
      items: [item],
      pickupDate: DateTime.parse('2025-10-24T09:30:00Z'),
      pickupTime: TimeOfDay(hour: 9, minute: 30),
      serviceType: null, // will produce empty service_name
      latitude: 12.34,
      longitude: 56.78,
    );

    final api = ApiService();

    // Call the public, testable conversion method
    final map = api.bookingRequestToJson(booking);

    // Basic shape checks
    expect(map, isA<Map<String, dynamic>>());
    expect(map.containsKey('service_name'), isTrue);
    expect(map.containsKey('date_time'), isTrue);
    expect(map.containsKey('time_slot'), isTrue);
    expect(map.containsKey('items'), isTrue);
    expect(map.containsKey('estimated_total'), isTrue);

    // Value checks
    expect(map['service_name'], equals('')); // serviceType was null
    expect(map['date_time'], equals(booking.pickupDate!.toIso8601String()));
    expect(map['time_slot'], equals('09:30'));
    expect(map['items'], isA<List>());
    expect((map['items'] as List).length, equals(1));

    // Check item fields serialized as expected
    final mItem = (map['items'] as List).first as Map;
    expect(mItem['id'], equals(101));
    // PickupItem.quantity is a getter that returns null in your model
    expect(mItem['quantity'], isNull);
    expect(mItem['name'], equals('Household Bag (Standard)'));
    // estimated_total should be 0.0 because item.quantity is null -> treated as 0
    expect((map['estimated_total'] as num).toDouble(), equals(0.0));

    // Encoding should succeed
    expect(() => jsonEncode(map), returnsNormally);
  });
}
