import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import '../view/go_routes/routes.dart';
import 'package:go_router/go_router.dart';
void main() async {
  //flutter has Binding which is responsible for connecting the flutter framework with the platform (android, ios, web).
  WidgetsFlutterBinding.ensureInitialized();
//firebase initialization is required before using any firebase services.
// it ensures that the firebase app is properly set up and ready to use.
  await Firebase.initializeApp(
    //options are required to specify the configuration for the firebase app.
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Firebase Connected");

  runApp(
    const ProviderScope(
      child: FoodRushApp(),
    ),
  );
}

class FoodRushApp extends StatelessWidget {
  const FoodRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FoodRush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter, // gorouter instance
    );
  }
}