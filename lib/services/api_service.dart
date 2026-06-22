// lib/services/api_service.dart

import 'package:flutter/foundation.dart';
import 'package:ggg_app/models/job.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_config.dart';

/// A service class responsible for all interactions with the GGG backend API.
class ApiService {
  // Uses the base URL defined in AppConfig (e.g., https://gogarbagegrabber.com/wp-json/ggg/v1)
  final String _baseUrl = AppConfig.baseUrl;

  get contractorId => null;

  final List<Job> _mockJobs = [
    Job(
      id: 'job-101',
      userId: 'customer-1',
      userName: 'Taylor',
      name: 'Furniture pickup',
      location: const GeoPoint(40.7128, -74.0060),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isCompleted: false,
      title: 'Furniture pickup',
      status: 'pending',
      address: '125 Main St',
      city: 'Anytown',
      notes: 'Couch and side table',
      price: 85.0,
    ),
    Job(
      id: 'job-102',
      userId: 'customer-2',
      userName: 'Jordan',
      name: 'Yard debris removal',
      location: const GeoPoint(40.7580, -73.9855),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isCompleted: true,
      title: 'Yard debris removal',
      status: 'completed',
      address: '89 Oak Ave',
      city: 'Anytown',
      notes: 'Bagged leaves and branches',
      price: 120.0,
    ),
  ];

  Future<List<Job>> listJobs(String contractor) async {
    debugPrint('Listing jobs from $_baseUrl for contractor: $contractor');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List<Job>.from(_mockJobs);
  }

  Future<List<Job>> fetchContractorJobs() async {
    final id = contractorId?.toString() ?? 'unknown-contractor';
    return listJobs(id);
  }

  Future<bool> updateJobStatus(String id, String status) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _mockJobs.indexWhere((job) => job.id == id);
    if (index == -1) return false;

    final markComplete = status.toLowerCase() == 'completed';
    _mockJobs[index] = _mockJobs[index].copyWith(isCompleted: markComplete);
    debugPrint('Updated job $id status to $status');
    return true;
  }
}
