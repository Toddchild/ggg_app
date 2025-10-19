// lib/services/firestore_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

// --- Global Variables (Provided by Canvas Environment) ---
// These variables are injected at runtime and must be used as-is.
// ignore: prefer_typing_uninitialized_variables, constant_identifier_names
const String __app_id = String.fromEnvironment('APP_ID');
// ignore: prefer_typing_uninitialized_variables, constant_identifier_names
const String __firebase_config = String.fromEnvironment('FIREBASE_CONFIG');
// ignore: prefer_typing_uninitialized_variables, constant_identifier_names
const String __initial_auth_token = String.fromEnvironment('AUTH_TOKEN');

/// A singleton service to manage Firebase initialization, authentication, and Firestore operations.
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  FirebaseApp? _app;
  FirebaseAuth? _auth;
  FirebaseFirestore? _db;
  String? _currentUserId;

  /// Initializes Firebase and authenticates the user.
  Future<void> initialize() async {
    if (_app != null) return; // Already initialized

    try {
      final firebaseConfig = jsonDecode(__firebase_config);
      _app = await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: firebaseConfig['apiKey'],
          appId: firebaseConfig['appId'],
          messagingSenderId: firebaseConfig['messagingSenderId'],
          projectId: firebaseConfig['projectId'],
          storageBucket: firebaseConfig['storageBucket'],
        ),
      );

      _auth = FirebaseAuth.instanceFor(app: _app!);
      _db = FirebaseFirestore.instanceFor(app: _app!);

      // Authenticate using the provided custom token or anonymously
      if (__initial_auth_token.isNotEmpty) {
        await _auth!.signInWithCustomToken(__initial_auth_token);
      } else {
        await _auth!.signInAnonymously();
      }

      _currentUserId = _auth!.currentUser?.uid;
    } catch (e) {
      debugPrint('Error initializing Firebase or signing in: $e');
      // If initialization fails, fall back to a dummy user ID to allow UI to render.
      _currentUserId =
          'anonymous-user-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Returns the currently authenticated user's ID or a dummy ID if initialization failed.
  String get userId {
    if (_currentUserId == null) {
      // Initialize if accessed before the future completes
      initialize();
      return 'initializing-user-id';
    }
    return _currentUserId!;
  }

  /// Gets the reference to the public bookings collection for the current app.
  CollectionReference get _bookingCollection {
    final appId = __app_id.isNotEmpty ? __app_id : 'default-app-id';
    // Path: /artifacts/{appId}/public/data/bookings
    return _db!
        .collection('artifacts')
        .doc(appId)
        .collection('public')
        .doc('data')
        .collection('bookings');
  }

  /// Saves the final booking details to Firestore.
  Future<void> saveBooking(BookingDetails details) async {
    await initialize(); // Ensure Firebase is ready

    final bookingMap = details.toMap();

    // Ensure the customerId is set to the authenticated user
    bookingMap['customerId'] = userId;

    // Add the document to the 'bookings' collection
    await _bookingCollection.add(bookingMap);
    debugPrint('Booking successfully saved to Firestore for user: $userId');
  }
}
