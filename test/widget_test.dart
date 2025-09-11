import 'package:flutter_test/flutter_test.dart';
import 'package:ggg_app/main.dart';

void main() {
  testWidgets('App boots and shows role selector', (WidgetTester tester) async {
    await tester.pumpWidget(const GGGApp());
    expect(find.text('Go Garbage Grabber'), findsOneWidget);
    expect(find.text('I’m a Customer'), findsOneWidget);
    expect(find.text('I’m a Contractor'), findsOneWidget);
  });
}
