import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:myapp/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('shows loading spinner before data loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows restaurant list after data loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('FoodRush title is shown in app bar', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pump();

    expect(find.text('FoodRush'), findsOneWidget);
  });

  testWidgets('search bar is visible on screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('tapping cart icon goes to cart page', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Cart'), findsOneWidget);
  });

  testWidgets('tapping orders icon goes to orders page', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodRushApp());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Orders'), findsOneWidget);
  });
}