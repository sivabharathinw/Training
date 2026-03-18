import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patrol/patrol.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/view/login_screen.dart';
import 'package:food_delivery/firebase_options.dart';

void main() {
  patrolSetUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  patrolTest(
    'Login flow test',

    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
        ($) async {
      // Start app
      await $.pumpWidgetAndSettle(
        const ProviderScope(child: FoodRushApp()),
      );




      expect(find.byType(LoginScreen), findsOneWidget);

      await $(TextField).at(0).enterText('bharu@gmail.com');
      await $(TextField).at(1).enterText('bharu@123');
      await $.native.pressBack();
      await $(ElevatedButton).tap();
      await $.pumpAndSettle();


      expect(find.text('FoodRush'), findsOneWidget);
    },
  );
}