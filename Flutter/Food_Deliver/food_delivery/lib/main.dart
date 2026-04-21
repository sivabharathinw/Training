import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import '../view/go_routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../core/services/appwrite_service.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
AppwriteService.init();

await Firebase.initializeApp(
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
routerConfig: appRouter,
);
}
}