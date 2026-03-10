import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CustomAnimatedBox());
  }
}

class CustomAnimatedBox extends StatefulWidget {
  const CustomAnimatedBox({super.key});

  @override
  _CustomAnimatedBoxState createState() => _CustomAnimatedBoxState();
}

class _CustomAnimatedBoxState extends State<CustomAnimatedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnim;
  late Animation<Color?> _colorAnim;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Size goes 100 to 200
    _sizeAnim = Tween<double>(begin: 100, end: 200)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Color goes Blue to Red
    _colorAnim = ColorTween(begin: Colors.blue, end: Colors.red)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Rotation 0 to 2*pi (full rotation)
    _rotationAnim = Tween<double>(begin: 0, end: 6.28)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Animation')),
      body: Center(
        child: CustomBox(
          sizeAnim: _sizeAnim,
          colorAnim: _colorAnim,
          rotationAnim: _rotationAnim,
        ),
      ),
    );
  }
}

class CustomBox extends AnimatedWidget {
  final Animation<double> sizeAnim;
  final Animation<Color?> colorAnim;
  final Animation<double> rotationAnim;

  const CustomBox({
    super.key,
    required this.sizeAnim,
    required this.colorAnim,
    required this.rotationAnim,
  }) : super(listenable: sizeAnim);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationAnim.value,
      child: Container(
        width: sizeAnim.value,
        height: sizeAnim.value,
        color: colorAnim.value,
      ),
    );
  }
}