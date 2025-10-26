import 'package:ggg_app/models/pickup_item.dart';

class BookingRequest {
  final String? address;
  final List<PickupItem> items;
  final DateTime? pickupDate;
  final dynamic pickupTime; // keep dynamic if different representations used (TimeOfDay or custom)
  final dynamic serviceType; // keep dynamic unless you have a concrete service type
  final double? latitude;
  final double? longitude;

  BookingRequest({
    this.address,
    List<PickupItem>? items,
    this.pickupDate,
    this.pickupTime,
    this.serviceType,
    this.latitude,
    this.longitude,
  }) : items = items ?? <PickupItem>[];

  BookingRequest copyWith({
    String? address,
    List<PickupItem>? items,
    DateTime? pickupDate,
    dynamic pickupTime,
    dynamic serviceType,
    double? latitude,
    double? longitude,
  }) {
    return BookingRequest(
      address: address ?? this.address,
      items: items ?? List<PickupItem>.from(this.items),
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      serviceType: serviceType ?? this.serviceType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
