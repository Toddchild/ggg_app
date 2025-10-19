import 'package:flutter/material.dart';
import '../models.dart';

/// Defines the two possible pickup windows.
enum TimeWindow { morning, afternoon }

/// Extension for easily getting the time range string.
extension TimeWindowExtension on TimeWindow {
  String get label => this == TimeWindow.morning ? '8:00 AM – 12:00 PM' : '12:00 PM – 6:00 PM';
}

/// A centralized data model to pass all collected booking information
/// between the Time, Location, and Confirmation pages.
@immutable
class BookingDetails {
  final Service service;
  final String customerName;
  final DateTime pickupDate;
  final TimeWindow pickupWindow;
  
  // Location and fee details
  final String? pickupLocationLabel; // e.g., "Curb/Driveway"
  final String? address; // NEW FIELD: The actual street address
  final double basePrice;
  final double finalFee;
  final int flightsOfStairs; // To carry forward from Location page

  const BookingDetails({
    required this.service,
    required this.customerName,
    required this.pickupDate,
    required this.pickupWindow,
    this.pickupLocationLabel,
    this.address, // Include in constructor
    required this.basePrice,
    required this.finalFee,
    required this.flightsOfStairs,
  });

  // Helper method to create a new instance with updated location/fee data
  BookingDetails copyWith({
    String? pickupLocationLabel,
    String? address, // Include in copyWith
    double? finalFee,
    int? flightsOfStairs,
  }) {
    return BookingDetails(
      service: service,
      customerName: customerName,
      pickupDate: pickupDate,
      pickupWindow: pickupWindow,
      pickupLocationLabel: pickupLocationLabel ?? this.pickupLocationLabel,
      address: address ?? this.address, // Update address
      basePrice: basePrice,
      finalFee: finalFee ?? this.finalFee,
      flightsOfStairs: flightsOfStairs ?? this.flightsOfStairs,
    );
  }
}
