import 'package:flutter/foundation.dart';

enum AppFlavor { customer, contractor }

class AppConfig {
  static late final AppFlavor flavor;
  static late final String baseUrl;

  static Future<void> initForApp(AppFlavor f) async {
    flavor = f;
    switch (flavor) {
      case AppFlavor.customer:
        baseUrl = const String.fromEnvironment('BASE_URL_CUSTOMER', defaultValue: 'https://api.example.com/customer');
        break;
      case AppFlavor.contractor:
        baseUrl = const String.fromEnvironment('BASE_URL_CONTRACTOR', defaultValue: 'https://api.example.com/contractor');
        break;
    }
    debugPrint('AppConfig initialized for $flavor with baseUrl=$baseUrl');
  }
}
