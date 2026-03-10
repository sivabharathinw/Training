import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RiveAnimationScreen(),
    );
  }
}

class RiveAnimationScreen extends StatelessWidget {
  const RiveAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rive Animation Example")),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: RiveAnimation.asset(
            'assets/riveanimation.riv',
            fit: BoxFit.contain,

          ),
        ),
      ),
    );
  }
}