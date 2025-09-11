import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

import 'screens/contractor_onboarding.dart';

void main() => runApp(const ContractorApp());

class ContractorApp extends StatefulWidget {
  const ContractorApp({super.key});
  @override
  State<ContractorApp> createState() => _ContractorAppState();
}

class _ContractorAppState extends State<ContractorApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _sub = uriLinkStream.listen(_handleIncomingLink, onError: (_) {});
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await getInitialUri();
      if (uri != null) _handleIncomingLink(uri);
    } catch (_) {}
  }

  void _handleIncomingLink(Uri uri) {
    if (uri.scheme == 'gggcontractor' && uri.host == 'onboarding') {
      _navKey.currentState?.pushNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  static final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGG – Contractor',
      navigatorKey: _navKey,
      routes: {
        '/': (ctx) => const _Home(),
        '/onboarding': (ctx) => const ContractorOnboardingScreen(),
      },
      initialRoute: '/',
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor App')),
      body: Center(
