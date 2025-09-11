// lib/services/ggg_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/job.dart';
import 'jobs_api.dart';

class GggApi implements JobsApi {
  GggApi({required this.user, required this.pass, String? baseUrl})
      : base = (baseUrl ?? AppConfig.baseUrl).replaceAll(RegExp(r'\/+$'), '');

  final String user;
  final String pass;
  final String base;

  Map<String, String> get _headers {
    final basic = base64Encode(utf8.encode('$user:$pass'));
    return {
      'Authorization': 'Basic $basic',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

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

  // ===== JobsApi =====

  @override
  Future<List<Job>> listJobs(String status) async {
    final uri = _u('/wp-json/ggg/v1/jobs', {'status': status});
    final res = await http.get(uri, headers: _headers);
    return _jobsFromRes(res);
  }

  @override
  Future<Job> getJob(int id) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id');
    final res = await http.get(uri, headers: _headers);
    return _jobFromRes(res);
  }

  @override
  Future<Job> accept(int id) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id/accept');
    final res = await http.post(uri, headers: _headers);
    return _jobFromRes(res);
  }

  @override
  Future<Job> arrive(int id) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id/arrive');
    final res = await http.post(uri, headers: _headers);
    return _jobFromRes(res);
  }

  @override
  Future<Job> cancel(int id) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id/cancel');
    final res = await http.post(uri, headers: _headers);
    return _jobFromRes(res);
  }

  @override
  Future<Job> escalate(int id, {String? message}) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id/escalate');
    final body = jsonEncode({'message': message ?? ''});
    final res = await http.post(uri, headers: _headers, body: body);
    return _jobFromRes(res);
  }

  @override
  Future<Job> complete(int id) async {
    final uri = _u('/wp-json/ggg/v1/jobs/$id/complete');
    final res = await http.post(uri, headers: _headers);
    return _jobFromRes(res);
  }
}
