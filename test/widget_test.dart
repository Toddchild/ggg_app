import 'package:flutter_test/flutter_test.dart';
import 'package:ggg_app/main_contractor.dart';

void main() {
  testWidgets('Contractor app boots and shows main navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ContractorMainApp());
    await tester.pump();

    expect(find.text('Garbage Grabber Pro'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Routes'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);
  });
}
