// lib/services/api_service.dart

import 'package:flutter/foundation.dart';
import 'package:ggg_app/models/job.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';

/// A service class responsible for all interactions with the GGG backend API.
class ApiService {
  // Uses the base URL defined in AppConfig (e.g., https://gogarbagegrabber.com/wp-json/ggg/v1)
  final String _baseUrl = AppConfig.baseUrl;

  get contractorId => null;

  Future listJobs(String s) async {}

  Future<List<Job>> fetchContractorJobs() async {
    return [];
  }

  Future updateJobStatus(String id, String s) async {}
}
