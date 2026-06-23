// lib/main.dart
// Recreated safe entrypoint: captures startup errors, optionally initializes
// Firebase (if used), and provides a minimal MyApp you can swap with your real
// app widget if you still have it elsewhere.
//
// IMPORTANT: WidgetsFlutterBinding.ensureInitialized() must be called in the
// same zone as runApp. This file initializes bindings and installs the
// platform error handler inside runZonedGuarded to avoid "Zone mismatch".

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

const String kAppId =
    String.fromEnvironment('APP_ID', defaultValue: 'my-app-id');

Future<void> main() async {
  // Run the whole startup sequence in a single zone so bindings and runApp
  // are created in the same zone (prevents "Zone mismatch" errors).
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Print uncaught errors on the root isolate to logcat / console so we can
    // diagnose "Could not prepare isolate" startup failures.
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint('UNCAUGHT ROOT ERROR: $error\n$stack');
      return true; // handled
    };

    try {
      // Initialize Firebase if available/needed. Errors are caught so app can
      // still start if initialization fails.
      await _maybeInitFirebase();
    } catch (e, st) {
      debugPrint('Firebase initialization threw: $e\n$st');
    }

    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    debugPrint('RUNZONEDG ERROR: $error\n$stack');
  });
}

Future<void> _maybeInitFirebase() async {
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized.');
  } catch (e) {
    debugPrint('Could not initialize Firebase (continuing): $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GGG App (recovery)',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GGG App — Recovery Main')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'This is a temporary recovery main.dart.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you have your original app widget (MyApp or similar) in another file, '
              'replace the runApp call in this file with your original widget.',
            ),
            const SizedBox(height: 16),
            const Text('appId (from --dart-define or default): $kAppId'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App is running (UI test).')),
                );
              },
              child: const Text('Smoke Test UI'),
            ),
            const SizedBox(height: 20),
            const Text(
              'To restore your original behavior:\n'
              '- If your original main.dart existed elsewhere, paste it back here.\n'
              '- Or swap `runApp(const MyApp())` with `runApp(YourOriginalApp())`.',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
