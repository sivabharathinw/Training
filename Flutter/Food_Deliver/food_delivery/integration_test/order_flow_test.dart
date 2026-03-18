import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:food_delivery/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Order Flow Integration Tests', () {

    testWidgets('Complete order flow - login to place order',
            (WidgetTester tester) async {

          app.main();

          // wait login screen to load
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Wait for textField to actually appear
          await tester.pump(const Duration(seconds: 2));

          // login
          await tester.enterText(find.byType(TextField).at(0), 'bharu@gmail.com');
          await tester.pump();
          await tester.enterText(find.byType(TextField).at(1), 'bharu@123');
          await tester.pump();

          await tester.tap(find.byKey(const Key('loginButton')));
          await tester.pumpAndSettle(const Duration(seconds: 8));

          // select first restaurant
          expect(find.byKey(const Key('restaurant_0')), findsOneWidget);
          await tester.tap(find.byKey(const Key('restaurant_0')));
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // add first menu item to cart
          expect(find.text('Add'), findsWidgets);
          await tester.tap(find.text('Add').first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // tap add to cart button
          expect(find.byKey(const Key('view_cart')), findsOneWidget);
          await tester.tap(find.byKey(const Key('view_cart')));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          //place order
          expect(find.byKey(const Key('place_order')), findsOneWidget);
          await tester.tap(find.byKey(const Key('place_order')));
          await tester.pumpAndSettle(const Duration(seconds: 5));
// view order details
          expect(find.byKey(const Key('view_orders_button')), findsOneWidget);
          await tester.tap(find.byKey(const Key('view_orders_button')));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // verify order confirmation
          expect(find.textContaining('My Order'), findsWidgets);

        });

  });
}