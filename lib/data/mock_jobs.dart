// lib/data/mock_jobs.dart
// Fingerprint: MOCK-JOBS-v3

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/job.dart';

class MockJobs {
  /// Jobs available to accept
  static final List<Job> open = <Job>[
    Job(
      id: '1001',
      title: 'Couch Pickup',
      status: 'open',
      address: '55 Parkstone Ave',
      city: 'Red Deer',
      notes: '1 couch, curbside',
      price: 65.0, userId: '', userName: '', name: '', location: const GeoPoint(0,0), createdAt: DateTime.now(), isCompleted: false,
    ),
    Job(
      id: '1002',
      title: 'Fridge Removal',
      status: 'open',
      address: '12 Norwood Close',
      city: 'Red Deer',
      notes: 'Stairs, bring dolly',
      price: 95.0, userId: '', userName: '', name: '', location: const GeoPoint(0,0), createdAt: DateTime.now(), isCompleted: false,
    ),
    Job(
      id: '1003',
      title: 'Yard Waste',
      status: 'open',
      address: '88 Piper Dr',
      city: 'Red Deer',
      notes: 'Bags + branches',
      price: 55.0, userId: '', userName: '', name: '', location: const GeoPoint(0,0), createdAt: DateTime.now(), isCompleted: false,
    ),
  ];

  /// Jobs already in my queue
  static final List<Job> mine = <Job>[
    Job(
      id: '2001',
      title: 'Garage Cleanout',
      status: 'accepted',
      address: '14 Ember Rd',
      city: 'Red Deer',
      notes: 'Half-bay of boxes',
      price: 120.0, userId: '', userName: '', name: '', location: const GeoPoint(0,0), createdAt: DateTime.now(), isCompleted: false,
    ),
    Job(
      id: '2002',
      title: 'Mattress Pickup',
      status: 'arrived',
      address: '77 Cornett Dr',
      city: 'Red Deer',
      notes: 'Queen mattress only',
      price: 80.0, userId: '', userName: '', name: '', location: const GeoPoint(0,0), createdAt: DateTime.now(), isCompleted: false,
    ),
  ];

  /// Find by id in either list
  static Job? find(String id) {
    try {
      return [
        ...open,
        ...mine,
      ].firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Update a job in-place inside the correct list (open/mine)
  static void upsert(Job job) {
    int i = mine.indexWhere((j) => j.id == job.id);
    if (i != -1) {
      mine[i] = job;
      return;
    }
    i = open.indexWhere((j) => j.id == job.id);
    if (i != -1) {
      open[i] = job;
      return;
    }
    // if not found, add to mine by default
    mine.add(job);
  }

  /// Move a job from `open` to `mine` when accepted
  /// Move a job from `open` to `mine` when accepted
  static void moveToMine(String id) {
    final idx = open.indexWhere((j) => j.id == id);
    if (idx != -1) {
      final j = open.removeAt(idx);
      mine.add(j);
    }
  }
}