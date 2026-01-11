import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';
import 'social_login_row.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final VoidCallback onToggle;

  const SignUpForm({super.key, required this.onToggle});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signUpWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
            _usernameController.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Please verify your email.'),
          ),
        );
        widget.onToggle(); // Switch to sign in
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple9,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Sign Up'),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        const SocialLoginRow(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              onPressed: widget.onToggle,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ],
    );
  }
}
