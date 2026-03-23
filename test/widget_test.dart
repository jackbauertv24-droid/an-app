import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:an_app/main.dart';

void main() {
  testWidgets('Cat Facts page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Cat Facts'), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.text('Press the button to get a cat fact!'), findsOneWidget);
    expect(find.text('Get Cat Fact'), findsOneWidget);
  });
}
