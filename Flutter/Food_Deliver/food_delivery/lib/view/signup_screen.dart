import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/app_repository.dart';
import '../view/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:appwrite/appwrite.dart';
import '../viewmodel/view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await ref.read(appProvider.notifier).signUp(email, password, name);
      
      if (!mounted) return;
      if (success) {
        context.go('/restaurants');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              key: const Key('name'),
              controller: nameController,
              label: 'Name',
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              key: const Key('signup_email'),
              controller: emailController,
              label: 'Email',
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              key: const Key('signup_password'),
              controller: passwordController,
              label: 'Password',
              obscureText: true,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              key: const Key('confirm_password'),
              controller: confirmPasswordController,
              label: 'Confirm Password',
              obscureText: true,
              enabled: !isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('signupButton'),
                onPressed: isLoading ? null : signup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up'),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: isLoading ? null : () => context.push('/login'),
              child: RichText(
                text: const TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Login',
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