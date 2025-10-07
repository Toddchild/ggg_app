// lib/services/ggg_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/job.dart';
import 'jobs_api.dart';

/// Default production base for the WordPress REST namespace.
const String kApiBase = 'https://gogarbagegrabber.com/wp-json/ggg/v1';

class GggApi implements JobsApi {
  GggApi({
    required this.user,
    required this.pass,
    String? baseUrl,
  }) : base = (
          // Prefer explicit override, then AppConfig, then constant.
          ((baseUrl ?? AppConfig.baseUrl).isNotEmpty
                  ? (baseUrl ?? AppConfig.baseUrl)
                  : kApiBase)
              .replaceAll(RegExp(r'\/+$'), '') // trim trailing slashes
        );

  final String user;
  final String pass;
  final String base;

  // --- Headers --------------------------------------------------------------

  // No Content-Type on GET to avoid unnecessary preflight in web builds.
  Map<String, String> get _headersGet {
    final basic = base64Encode(utf8.encode('$user:$pass'));
    return {
      'Authorization': 'Basic $basic',
      'Accept': 'application/json',
    };
  }

  // JSON headers for POST endpoints that send JSON bodies.
  Map<String, String> get _headersJson {
    final basic = base64Encode(utf8.encode('$user:$pass'));
    return {
      'Authorization': 'Basic $basic',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // --- Utils ----------------------------------------------------------------

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('$base$path').replace(queryParameters: q);

  Job _jobFromRes(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return Job.fromJson(map);
  }

  List<Job> _jobsFromRes(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Job.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- JobsApi --------------------------------------------------------------

  @override
  Future<List<Job>> listJobs(String status) async {
    final uri = _u('/jobs', {
      'status': status,
      'city': AppConfig.defaultCity,

    });
    final res = await http.get(uri, headers: _headersGet);
    return _jobsFromRes(res);
  }

  @override
  Future<Job> getJob(int id) async {
    final uri = _u('/jobs/$id');
    final res = await http.get(uri, headers: _headersGet);
    return _jobFromRes(res);
  }

  @override
  Future<Job> accept(int id) async {
    final uri = _u('/jobs/$id/accept');
    final res = await http.post(uri, headers: _headersJson);
    return _jobFromRes(res);
  }

  @override
  Future<Job> arrive(int id) async {
    final uri = _u('/jobs/$id/arrive');
    final res = await http.post(uri, headers: _headersJson);
    return _jobFromRes(res);
  }

  @override
  Future<Job> cancel(int id) async {
    final uri = _u('/jobs/$id/cancel');
    final res = await http.post(uri, headers: _headersJson);
    return _jobFromRes(res);
  }

  @override
  Future<Job> escalate(int id, {String? message}) async {
    final uri = _u('/jobs/$id/escalate');
    final body = jsonEncode({'message': message ?? ''});
    final res = await http.post(uri, headers: _headersJson, body: body);
    return _jobFromRes(res);
  }

  @override
  Future<Job> complete(int id) async {
    final uri = _u('/jobs/$id/complete');
    final res = await http.post(uri, headers: _headersJson);
    return _jobFromRes(res);
  }

  /// Upload a job photo (expects at least 2 before /complete succeeds).
  /// Sends as `application/x-www-form-urlencoded` to match your working curl.
  Future<void> uploadPhoto(int id, List<int> bytes) async {
    final b64 = base64Encode(bytes);
    final uri = _u('/jobs/$id/photo');
    final res = await http.post(
      uri,
      // Auth + Accept only; no Content-Type so it posts as form-encoded.
      headers: _headersGet,
      body: {'image_b64': b64},
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
