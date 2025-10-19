import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and shows role selector', (WidgetTester tester) async {
    await tester.pumpWidget(const GGGApp() as Widget);
    expect(find.text('Go Garbage Grabber'), findsOneWidget);
    expect(find.text('I’m a Customer'), findsOneWidget);
    expect(find.text('I’m a Contractor'), findsOneWidget);
  });
}

class GGGApp {
  const GGGApp();
}
