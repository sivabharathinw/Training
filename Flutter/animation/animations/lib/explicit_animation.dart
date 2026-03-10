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
      home: ExplicitAnimationScreen(),
    );
  }
}

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // convert controller value (0-1) to 100-200 using Tween
    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        // curve: Curves.easeInOut,
        // reverseCurve: Curves.easeOut,
        curve:Curves.bounceIn,
        reverseCurve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explicit Animation"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        //whenevr the value chnages the animatedBuilder will rebuild the widget tree and update the UI with the new value of the animation.
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _animation.value,
              height: _animation.value,
              decoration: const BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle, // fix: use BoxDecoration for shape
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isCompleted) {
            _controller.reverse(); // reverse animation
          } else {
            _controller.forward(); // forward animation that starts the animation and chnage the value of the controller from 0 to 1 and then the tween will convert it to 100 to 200
          }
        },
        child: const Icon(Icons.rocket_sharp),
      ),
    );
  }
}