import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:an_app/main.dart';
import 'package:an_app/providers/account_provider.dart';
import 'package:an_app/providers/cart_provider.dart';
import 'package:an_app/providers/orders_provider.dart';
import 'package:an_app/providers/locale_provider.dart';

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

  testWidgets('Demo accounts are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewDirectApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Check for demo accounts (account names are in English)
    expect(find.text('Downtown Bar & Grill'), findsOneWidget);
    expect(find.text('The Italian Kitchen'), findsOneWidget);
    expect(find.text('Corner Market & Spirits'), findsOneWidget);
  });
}
