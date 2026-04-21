import 'package:flutter/material.dart';

class MobileOnboarding extends StatelessWidget {
  const MobileOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.blue,
            child: const Center(
              child: Text(
                "Welcome to WidgetHub!",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.green,
            child: const Center(
              child: Text(
                "Manage your tasks easily",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.orange,
            child: const Center(
              child: Text(
                "Explore FAQs and settings",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to dashboard
          },
          child: const Text("Get Started"),
        ),
      ),
    );
  }
}