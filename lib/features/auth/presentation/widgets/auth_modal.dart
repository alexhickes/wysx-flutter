import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

import 'sign_in_form.dart';
import 'sign_up_form.dart';

class AuthModal extends ConsumerStatefulWidget {
  const AuthModal({super.key});

  @override
  ConsumerState<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends ConsumerState<AuthModal> {
  bool _isSignUp = false;

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          const Icon(Icons.location_on, size: 48, color: AppColors.purple9),
          const SizedBox(height: 16),
          Text(
            'Wys X',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'What you saying?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Form
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSignUp
                ? SignUpForm(
                    key: const ValueKey('signup'),
                    onToggle: _toggleMode,
                  )
                : SignInForm(
                    key: const ValueKey('signin'),
                    onToggle: _toggleMode,
                  ),
          ),
        ],
      ),
    );
  }
}
