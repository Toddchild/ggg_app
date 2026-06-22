import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ggg_app/main.dart';

void main() {
  testWidgets('Contractor app boots and tab navigation works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ContractorMainApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Garbage Grabber Pro'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Routes'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);

    await tester.tap(find.text('Routes'));
    await tester.pumpAndSettle();
    expect(find.text('My Active Routes & Map'), findsOneWidget);

    await tester.tap(find.text('Earnings'));
    await tester.pumpAndSettle();
    expect(find.text('Earnings & Payout History'), findsOneWidget);
  });
}
