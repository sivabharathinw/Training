import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Worker function for isolate
void heavyTaskIsolate(SendPort sendPort) {
  int sum = 0;
  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }
  sendPort.send("isolate completed");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = "press a button to start";


  void calculation() {
    int sum = 0;
    for (int i = 0; i < 100000000; i++) {
      sum += i;
    }
    setState(() {
      result = "normal calculation completed";
    });
  }


  void isolatedCalculation() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(heavyTaskIsolate, receivePort.sendPort);


    receivePort.listen((message) {
      setState(() {
        result = message;
      });
      receivePort.close();
    });
  }

  void futureCalculation() {
    Future(() {
      int sum = 0;
      for (int i = 0; i < 100000000; i++) {
        sum += i;
      }
      setState(() {
        result = "future completed";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("isolation example")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(result, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: calculation, child: const Text("heavy task")),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: isolatedCalculation, child: const Text("isolate  task")),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: futureCalculation, child: const Text("fruture task")),
            ],
          ),
        ),
      ),
    );
  }
}