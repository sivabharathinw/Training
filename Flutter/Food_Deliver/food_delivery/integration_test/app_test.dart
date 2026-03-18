import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery/view/login_screen.dart';
import 'package:food_delivery/firebase_options.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  //testWidgsts is used to test the entire flow of the app, from login to placing an order.
  // It simulates user interactions and checks if the expected widgets are present at each step.
  //WidfgetTester is used to interact with the widgets in the app, such as entering text, tapping buttons, and waiting for animations to settle.
  testWidgets('Order flow test', (WidgetTester tester) async {

    // start app --pumpWidget is used to build the widget tree and render the app on the screen.
    await tester.pumpWidget(
      const ProviderScope(child: FoodRushApp()),
    );
    await tester.pumpAndSettle();

    //  Login
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'bharu@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'bharu@123');
    await tester.tap(find.byType(ElevatedButton));
    //here pumpbdAettele is used to wait for the login process to complete and for the app to navigate to the next screen.5 seconds is given to ensure that the login process has enough time to complete and
    // the next screen is fully loaded before the test continues.
    await tester.pumpAndSettle(const Duration(seconds: 5));

    //  Restaurant list
    expect(find.text('FoodRush'), findsOneWidget);
    //3 seonds is given to ensure that the restaurant list has enough time to load and render on the screen before the test continues.
    //it maes to wait for 3 secoindds to  ensure that the restaurant list has enough time to load and render on the screen before the test continues. This is important because the restaurant list may take some time to fetch data from the server and display it on the screen, and without this wait
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap first restaurant
    expect(find.byType(GestureDetector), findsWidgets);
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // //  Wait for menu to load
    // await tester.pumpAndSettle(const Duration(seconds: 3));

    //  Tap Add button
    expect(find.text('Add'), findsWidgets);
    await tester.tap(find.text('Add').first);

    //  Wait for snackbar to finish

    //the first pump is used to start the snackbar animation,
    // and the second pump with a duration of 1 second is used to wait for the animation to complete
    // The third pump with a duration of 50 milliseconds is used to ensure that any remaining animations or state changes related to the snackbar are settled before the test continues.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    // tap cart icon
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // confirm cart screen
    expect(find.text('Your Cart'), findsOneWidget);

    //  tap place Order
    expect(find.textContaining('Place Order'), findsOneWidget);
    await tester.tap(find.textContaining('Place Order'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    //  check dialog
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Order Placed!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));

    //  tap View Orders
    await tester.tap(find.text('View Orders'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // dialog closes
    await tester.pump(const Duration(milliseconds: 300)); // navigation starts
    await tester.pump(const Duration(seconds: 2)); // orders page loads


    //  confirm orders screen
    expect(find.text('My Orders'), findsOneWidget);

  });
}