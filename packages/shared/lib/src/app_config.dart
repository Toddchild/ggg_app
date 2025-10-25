import 'package:flutter/foundation.dart';

enum AppFlavor {
  customer,
  contractor,
}

class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;

  AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw StateError('AppConfig has not been initialized. Call AppConfig.init() first.');
    }
    return _instance!;
  }

  static void init({
    required AppFlavor flavor,
    required String appName,
    required String apiBaseUrl,
  }) {
    _instance = AppConfig(
      flavor: flavor,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
    );
  }

  bool get isCustomer => flavor == AppFlavor.customer;
  bool get isContractor => flavor == AppFlavor.contractor;

  @override
  String toString() {
    return 'AppConfig(flavor: $flavor, appName: $appName, apiBaseUrl: $apiBaseUrl)';
  }
}
