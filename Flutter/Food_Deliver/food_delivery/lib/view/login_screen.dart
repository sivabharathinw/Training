import 'package:flutter/material.dart';
import '../repository/app_repository.dart';
import 'signup_screen.dart';
import 'restaurant_list_screen.dart';
import '../view/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:appwrite/appwrite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final AppRepository _repository = AppRepository();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      await _repository.auth.login(email, password);
      if (mounted) {
        GoRouter.of(context).push('/restaurants');
      }
    } on AppwriteException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'FoodRush',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              key: const Key('email'),
              controller: emailController,
              label: 'Email',
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              key: const Key('password'),
              controller: passwordController,
              label: 'Password',
              obscureText: true,
              enabled: !isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('loginButton'),
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: isLoading ? null : () => context.push('/signup'),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}