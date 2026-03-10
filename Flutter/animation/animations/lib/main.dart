import "package:flutter/material.dart";

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

  double width = 200;
  double height = 200;
  Color color = Colors.purple;

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
          child: const Center(
            child: Text(
              "Hello Flutter",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
           width= width ==200?400:200;
            height=height == 200?400:200;
           color= color ==Colors.purple? Colors.red:Colors.purple;
          });
        },
        child: const Icon(Icons.play_arrow),

      ),
    );
  }
}