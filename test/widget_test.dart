import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aiopoly/main.dart';

void main() {
  testWidgets('Home route smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the title of the app is shown.
    expect(find.text('AIopoly'), findsOneWidget);

    // Verify that the prompt text is present.
    expect(find.text('Enter a theme for your game'), findsOneWidget);

    // Verify that the text field is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the Generate button is present.
    expect(find.text('Generate'), findsOneWidget);
  });
}
