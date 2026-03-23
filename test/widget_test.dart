import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:an_app/main.dart';
import 'package:an_app/providers/account_provider.dart';
import 'package:an_app/providers/cart_provider.dart';
import 'package:an_app/providers/orders_provider.dart';

void main() {
  testWidgets('Account selection screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewDirectApp());

    // Check for BrewDirect branding
    expect(find.text('BrewDirect'), findsOneWidget);
    expect(find.text('Wholesale Beer Distribution'), findsOneWidget);
    expect(find.text('Select Your Account'), findsOneWidget);
  });

  testWidgets('Demo accounts are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewDirectApp());

    // Check for demo accounts
    expect(find.text('Downtown Bar & Grill'), findsOneWidget);
    expect(find.text('The Italian Kitchen'), findsOneWidget);
    expect(find.text('Corner Market & Spirits'), findsOneWidget);
  });
}
