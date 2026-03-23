import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:an_app/main.dart';

void main() {
  testWidgets('Account selection screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewDirectApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Check for Chinese branding (default language is Traditional Chinese)
    expect(find.text('青啤直銷'), findsOneWidget);
    expect(find.text('啤酒批發配送'), findsOneWidget);
    expect(find.text('選擇您的帳戶'), findsOneWidget);
  });

  testWidgets('Account cards are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewDirectApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Check for account type icons (at least one Card widget exists)
    expect(find.byType(Card), findsWidgets);
  });
}
