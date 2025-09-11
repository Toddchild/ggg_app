// lib/services/ggg_api_mock.dart
// Fingerprint: GGG-API-MOCK-v3

import 'dart:async';
import '../models/job.dart';
import '../data/mock_jobs.dart';
import 'jobs_api.dart';

class GggApiMock implements JobsApi {
  const GggApiMock();

  Future<T> _latency<T>(T value) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return value;
  }

  Job _with(Job j, {String? status, String? notes}) => Job(
        id: j.id,
        title: j.title,
        status: status ?? j.status,
        address: j.address,
        city: j.city,
        notes: notes ?? j.notes,
        price: j.price,
      );

  @override
  Future<List<Job>> listJobs(String status) async {
    switch (status.toLowerCase()) {
      case 'open':
        return _latency(List<Job>.from(MockJobs.open));
      case 'mine':
        return _latency(List<Job>.from(MockJobs.mine));
      default:
        final all = [...MockJobs.open, ...MockJobs.mine];
        return _latency(all
            .where((j) => (j.status ?? '').toLowerCase() == status.toLowerCase())
            .toList());
    }
  }

  @override
  Future<Job> getJob(int id) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');
    return _latency(j);
  }

  @override
  Future<Job> accept(int id) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');
    final updated = _with(j, status: 'accepted');
    MockJobs.upsert(updated);
    MockJobs.moveToMine(id);
    return _latency(updated);
  }

  @override
  Future<Job> arrive(int id) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');
    final updated = _with(j, status: 'arrived');
    MockJobs.upsert(updated);
    return _latency(updated);
  }

  @override
  Future<Job> complete(int id) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');
    final updated = _with(j, status: 'completed');
    MockJobs.upsert(updated);
    return _latency(updated);
  }

  @override
  Future<Job> cancel(int id) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');
    final updated = _with(j, status: 'open');
    MockJobs.upsert(updated);

    // ensure it sits in OPEN, not in MINE
    final iMine = MockJobs.mine.indexWhere((x) => x.id == id);
    if (iMine != -1) MockJobs.mine.removeAt(iMine);
    final inOpen = MockJobs.open.any((x) => x.id == id);
    if (!inOpen) MockJobs.open.add(updated);

    return _latency(updated);
  }

  @override
  Future<Job> escalate(int id, {String? message}) async {
    final j = MockJobs.find(id);
    if (j == null) throw StateError('Mock job $id not found');

    final combinedNotes = [
      if (j.notes != null && j.notes!.isNotEmpty) j.notes!,
      if (message != null && message.isNotEmpty) 'NOTE: $message',
    ].join(' • ');

    final updated = _with(
      j,
      status: 'escalated',
      notes: combinedNotes.isEmpty ? j.notes : combinedNotes,
    );
    MockJobs.upsert(updated);
    return _latency(updated);
  }
}
