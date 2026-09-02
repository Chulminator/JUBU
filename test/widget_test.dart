import 'package:flutter_test/flutter_test.dart';

import 'package:jubu/main.dart';

void main() {
  testWidgets('App shows the placeholder home text', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Hello World!'), findsOneWidget);
  });
}
