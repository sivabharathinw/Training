// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/repository/app_repository.dart';

import 'view/restaurant_list_screen.dart';


void main() {
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
    return MaterialApp(
      title: 'FoodRush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          primary: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const RestaurantListScreen(),
    );



















































  }
}
