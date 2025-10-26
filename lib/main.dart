// lib/main.dart
// Safe app entrypoint with robust error reporting hooks and a small recovery UI.
//
// Notes:
// - This file intentionally does NOT import firebase_crashlytics to keep this
//   file usable in repos that don't depend on Crashlytics. If you use
//   firebase_crashlytics, add the package to pubspec.yaml and set the
//   `globalErrorReporter` after initializing Crashlytics (example below).
//
// Example to wire Crashlytics (after adding dependency):
//   import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//   globalErrorReporter = (Object error, StackTrace stack, {bool fatal = false}) async {
//     await FirebaseCrashlytics.instance.recordError(error, stack, reason: fatal ? 'fatal' : 'non-fatal');
//   };
//
// The runZonedGuarded + PlatformDispatcher.onError setup below ensures errors
// are logged and forwarded to any configured reporter.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

const String kAppId =
    String.fromEnvironment('APP_ID', defaultValue: 'my-app-id');

/// Application-level pluggable error reporter.
///
/// If you use a crash-reporting service (eg. Firebase Crashlytics), set this
/// to a function that forwards errors to that service after initialization.
typedef ErrorReporter = Future<void> Function(Object error, StackTrace stack,
    {bool fatal});

ErrorReporter? globalErrorReporter;

Future<void> main() async {
  // Run the whole startup sequence in a single zone so bindings and runApp
  // are created in the same zone (prevents "Zone mismatch" errors).
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Report uncaught errors on the root isolate. Forward to configured
    // reporter if present; otherwise log to console.
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _handleUncaughtError(error, stack, fatal: true);
      // Return true to indicate we've handled it (prevents default termination).
      // If you want the process to terminate, return false.
      return true;
    };

    try {
      await _maybeInitFirebase();
    } catch (e, st) {
      // Initialization itself failed — surface it.
      debugPrint('Firebase initialization threw: $e\n$st');
    }

    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    // Zonal uncaught errors (async).
    _handleUncaughtError(error, stack, fatal: false);
  });
}

Future<void> _maybeInitFirebase() async {
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized.');

    // If you want to wire Crashlytics at runtime and you have added the
    // firebase_crashlytics package, set globalErrorReporter here. Example:
    //
    // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
    // globalErrorReporter = (error, stack, {fatal = false}) async {
    //   await FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
    // };
    //
    // Optionally route Flutter framework errors to Crashlytics:
    // FlutterError.onError = (details) {
    //   FlutterError.presentError(details);
    //   FirebaseCrashlytics.instance.recordFlutterError(details);
    // };
  } catch (e) {
    // Keep app resilient if Firebase is unavailable.
    debugPrint('Could not initialize Firebase (continuing): $e');
  }
}

void _handleUncaughtError(Object error, StackTrace stack,
    {required bool fatal}) {
  // Forward to configured reporter if present.
  if (globalErrorReporter != null) {
    // Do not await here to avoid blocking the error handler; but capture any
    // error from the reporter itself.
    unawaited(
        globalErrorReporter!(error, stack, fatal: fatal).catchError((e, st) {
      debugPrint('Error while reporting uncaught error: $e\n$st');
    }));
  } else {
    // Default logging for environments without an external reporter.
    debugPrint('UNCAUGHT ERROR${fatal ? " (fatal)" : ""}: $error\n$stack');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GGG App (recovery)',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Column content can overflow on small devices — wrap in a scroll view.
    return Scaffold(
      appBar: AppBar(title: const Text('GGG App — Recovery Main')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
