import 'package:flutter/material.dart';
import 'package:custom_alert/custom_alert.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Alert")),
      body: Center(
        child:Column(
          children: [ ElevatedButton(
            onPressed: () {
              CustomAlert.show(
                context,
                title: "Hello",
                message: "This is my custom alert!",
              );
            },
            child: Text("Show Alert"),
          ),
            ElevatedButton(
              onPressed: () {
                CustomAlert.show(
                  context,
                  title: "Hello",
                  message: "This is my next custom alert!",
                );
              },
              child: Text("Show next Alert"),
            ),
          ]

      ),
      ) );
  }
}