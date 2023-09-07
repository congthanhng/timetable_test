import 'package:flutter_test/flutter_test.dart';
import 'package:timetable_test/app/app_shelf.dart';
import 'package:timetable_test/timetable/timetable_shelf.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(TimetablePage), findsOneWidget);
    });
  });
}
