import 'package:flutter/material.dart';

/// Defines the possible pickup windows.
enum TimeWindow { morning, afternoon }

/// Defines the job status, visible to both customer and contractor.
enum JobStatus { pending, accepted, completed, cancelled }

/// Extension for easily getting the time range string.
extension TimeWindowExtension on TimeWindow {
  String get label => this == TimeWindow.morning ? '8:00 AM – 12:00 PM' : '12:00 PM – 6:00 PM';
  String get id => name; // Use enum name for serialization
}

/// A centralized data model for a job/booking, ready for Firestore serialization/deserialization.
@immutable
class BookingDetails {
  final String id; // Firestore document ID
  final String customerName;
  final String customerId; // The ID of the user who created the job
  final DateTime pickupDate;
  final TimeWindow pickupWindow;
  
  // Service details (stored denormalized)
  final String serviceName;
  final int serviceMinutes;
  final double basePrice;

  // Location and fees
  final String pickupLocationLabel; // e.g., "Curb/Driveway"
  final String address; 
  final double finalFee;
  final int flightsOfStairs; 

  // Contractor details
  final String? contractorId;
  final JobStatus status;

  const BookingDetails({
    this.id = '',
    required this.customerName,
    required this.customerId,
    required this.pickupDate,
    required this.pickupWindow,
    required this.serviceName,
    required this.serviceMinutes,
    required this.basePrice,
    required this.pickupLocationLabel,
    required this.address, 
    required this.finalFee,
    required this.flightsOfStairs,
    this.contractorId,
    this.status = JobStatus.pending,
  });

  /// Converts this object to a Map for storage in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerId': customerId,
      'pickupDate': pickupDate.toUtc().toIso8601String(), // UTC for consistency
      'pickupWindow': pickupWindow.id,
      'serviceName': serviceName,
      'serviceMinutes': serviceMinutes,
      'basePrice': basePrice,
      'pickupLocationLabel': pickupLocationLabel,
      'address': address,
      'finalFee': finalFee,
      'flightsOfStairs': flightsOfStairs,
      'contractorId': contractorId,
      'status': status.name,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  /// Creates a BookingDetails object from a Firestore document snapshot.
  factory BookingDetails.fromMap(String id, Map<String, dynamic> map) {
    // Helper to safely parse strings that might be missing or null
    String safeString(dynamic value) => (value ?? 'N/A') as String;
    
    return BookingDetails(
      id: id,
      customerName: safeString(map['customerName']),
      customerId: safeString(map['customerId']),
      pickupDate: DateTime.parse(safeString(map['pickupDate'])).toLocal(),
      pickupWindow: TimeWindow.values.firstWhere(
        (e) => e.name == safeString(map['pickupWindow']), 
        orElse: () => TimeWindow.morning // Default to morning if invalid
      ),
      serviceName: safeString(map['serviceName']),
      serviceMinutes: (map['serviceMinutes'] as num? ?? 0).toInt(),
      basePrice: (map['basePrice'] as num? ?? 0.0).toDouble(),
      pickupLocationLabel: safeString(map['pickupLocationLabel']),
      address: safeString(map['address']),
      finalFee: (map['finalFee'] as num? ?? 0.0).toDouble(),
      flightsOfStairs: (map['flightsOfStairs'] as num? ?? 0).toInt(),
      contractorId: safeString(map['contractorId']) == 'N/A' ? null : safeString(map['contractorId']),
      status: JobStatus.values.firstWhere(
        (e) => e.name == safeString(map['status']), 
        orElse: () => JobStatus.pending // Default to pending if invalid
      ),
    );
  }
}
