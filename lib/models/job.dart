import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String userId; // <-- CRITICAL: Must be defined here
  final String userName;
  final String name;
  final GeoPoint location;
  final DateTime createdAt;
  final bool isCompleted; // <-- CRITICAL: Must be defined here

  const Job({
    required this.id,
    required this.userId, // <-- CRITICAL: Must be required in constructor
    required this.userName,
    required this.name,
    required this.location,
    required this.createdAt,
    required this.isCompleted, required String title, required String status, required String address, required String city, required String notes, required double price, // <-- CRITICAL: Must be required in constructor
  });

  // Factory method to create a Job from a Firestore Map
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      location: json['location'] as GeoPoint,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'] as bool, title: '', status: '', address: '', city: '', notes: '', price: 0.0,
    );
  }

  get pickupTime => null;

  get status => null;

  String? get title => null;

  get contractorId => null;

  get price => null;

  String? get address => null;

  bool? get isAccepting => null;

  String? get city => null;

  get notes => null;

  set isAccepting(bool? isAccepting) {}

  // Method to convert the Job object to a Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'name': name,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
    };
  }

  Job copyWith({
    bool? isCompleted,
  }) {
    return Job(
      id: id,
      userId: userId,
      userName: userName,
      name: name,
      location: location,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted, title: '', status: '', address: '', city: '', notes: '', price: 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  static fromMap(Map<String, dynamic> data, String id) {}
}
