import 'package:ggg_app/models/booking_request.dart';
// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggg_app/models/job.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';

/// A service class responsible for all interactions with the GGG backend API.
class ApiService {
  // Uses the base URL defined in AppConfig (e.g., https://gogarbagegrabber.com/wp-json/ggg/v1)
  final String _baseUrl = AppConfig.baseUrl;

  get contractorId => null;

  /// Converts the complex BookingRequest object into a JSON format suitable for the API.
  /// Made public and annotated with @visibleForTesting so unit tests can call it.
  @visibleForTesting
  Map<String, dynamic> bookingRequestToJson(BookingRequest request) {
    // Note: The backend API expects a specific structure.
    // Ensure these keys match your backend implementation (e.g., WordPress/WooCommerce).
    return {
      // Basic Booking Details
      'service_name': request.serviceType?.name ?? '',
      'date_time': request.pickupDate!.toIso8601String(),
      'time_slot': request.pickupTime != null
          ? '${(request.pickupTime is TimeOfDay ? request.pickupTime.hour : request.pickupTime.hour).toString().padLeft(2, '0')}:${(request.pickupTime is TimeOfDay ? request.pickupTime.minute : request.pickupTime.minute).toString().padLeft(2, '0')}'
          : null,
      'address': request.address,
      'latitude': request.latitude,
      'longitude': request.longitude,

      // Items and Pricing Summary
      'items': request.items
          .map((item) => {
                'id': item.id, // Item ID used by the backend
                'quantity': item.quantity,
                'name': item.name,
                'price': item.basePrice,
              })
          .toList(),

      'estimated_total': request.items.fold(
          0.0, (sum, item) => sum + ((item.basePrice) * (item.quantity ?? 0))),
      // TODO: You may need to add customer identification, email, phone, etc. here.
    };
  }

  /// Sends the booking request to the backend API.
  Future<bool> submitBooking(BookingRequest request) async {
    // Example endpoint for booking creation
    final uri = Uri.parse('$_baseUrl/create-booking');

    try {
      // Use the public conversion method here
      final bodyJson = bookingRequestToJson(request);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Add API Key or Authorization header here if needed
        },
        body: jsonEncode(bodyJson),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // HTTP success code
        return true;
      } else {
        // Log API-specific errors (e.g., validation failed, 400 bad request)
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Log network errors (e.g., no internet, host unreachable)
      debugPrint('Network Error: $e');
      return false;
    }
  }

  Future listJobs(String s) async {}

  Future<List<Job>> fetchContractorJobs() async {
    return [];
  }

  Future updateJobStatus(String id, String s) async {}
}
