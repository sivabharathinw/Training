import 'package:flutter/material.dart';
import 'package:vibrate_plugin/vibrate_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Vibrate Plugin Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await VibratePlugin().vibrate(duration: 500);
            },
            child: const Text('Vibrate!'),
          ),
        ),
      ),
    );
  }
}