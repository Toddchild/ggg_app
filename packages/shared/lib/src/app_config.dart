import 'package:flutter/foundation.dart';

enum AppFlavor { customer, contractor }

class AppConfig {
  static late final AppFlavor _flavor;

  static AppFlavor get flavor => _flavor;

  static Future<void> initForApp(AppFlavor flavor) async {
    _flavor = flavor;
    // Add async initialization here if needed.
    if (kDebugMode) {
      // debugPrint('AppConfig initialized for $flavor');
    }
    await Future<void>.value();
  }
}
