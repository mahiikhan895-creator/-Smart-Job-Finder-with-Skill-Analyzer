import 'package:flutter_test/flutter_test.dart';
import 'package:smart_job_finder/main.dart';

void main() {
  testWidgets('App should load', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartJobFinderApp());

    // Verify that the app title is present
    expect(find.text('Smart Job Finder'), findsOneWidget);
  });
}
