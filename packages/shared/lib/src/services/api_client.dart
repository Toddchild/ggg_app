import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contractor.dart';
import '../app_config.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  Future<bool> applyForContractor(Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/contractors/apply');
    final r = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return r.statusCode == 200 || r.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> fetchAvailableJobs({double? lat, double? lng}) async {
    final uri = Uri.parse('$baseUrl/jobs/available${lat != null ? '?lat=$lat&lng=$lng' : ''}');
    final r = await http.get(uri);
    if (r.statusCode != 200) throw Exception('Failed to fetch jobs');
    return List<Map<String, dynamic>>.from(jsonDecode(r.body) as List);
  }

  Future<void> acceptJob(String jobId, String contractorId) async {
    final uri = Uri.parse('$baseUrl/jobs/$jobId/accept');
    final r = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'contractor_id': contractorId}));
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('Could not accept job: ${r.statusCode} ${r.body}');
    }
  }

  Future<Contractor> getContractor(String id) async {
    final uri = Uri.parse('$baseUrl/contractors/$id');
    final r = await http.get(uri);
    if (r.statusCode != 200) throw Exception('Failed to load contractor');
    return Contractor.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }
}
