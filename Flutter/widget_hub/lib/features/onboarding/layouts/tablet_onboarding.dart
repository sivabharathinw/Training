import 'package:flutter/material.dart';

class TabletOnboarding extends StatelessWidget {
  const TabletOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: PageView(
              children: [
                Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "Welcome to WidgetHub!",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      "Manage your tasks easily",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      "Explore FAQs and settings",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: const Center(child: Text("Tablet Sidebar / Info Panel")),
            ),
          ),
        ],
      ),
    );
  }
}