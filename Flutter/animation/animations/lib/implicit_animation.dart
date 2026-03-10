import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animations in Flutter',
      home: ImplicitAnimationScreen(),
    );
  }
}

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  double width = 100;
  double height = 100;
  Color color = Colors.purple;
  bool showText = false; // controls text visibility

  void cart() {
    setState(() {
      width = width == 100 ? 200 : 100;
      height = height == 100 ? 200 : 100;
      color = color == Colors.purple ? Colors.red : Colors.purple;
      showText = true; // show text after click
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animation"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: width,
          height: height,
          color: color,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Colors.white,
                iconSize: 40,
                onPressed: cart,
              ),
              if (showText) const SizedBox(height: 10), // gap between icon & text
              if (showText)
                const Text(
                  "Added to cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}