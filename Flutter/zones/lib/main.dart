import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint("Error: $error");
    debugPrintStack(stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void triggerError() {
    Future.microtask(() {
      throw Exception("Simple UI Error!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zone Simple UI")),
      body: Center(
        child: ElevatedButton(
          onPressed: triggerError,
          child: const Text("Click to Throw Error"),
        ),
      ),
    );
  }
}