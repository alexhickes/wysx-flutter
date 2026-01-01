import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

class SocialLoginRow extends ConsumerWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Icons.g_mobiledata, // Placeholder for Google Logo
          onPressed: () => ref.read(authRepositoryProvider).signInWithGoogle(),
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon: Icons.facebook,
          onPressed: () =>
              ref.read(authRepositoryProvider).signInWithFacebook(),
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon: Icons.apple,
          onPressed: () => ref.read(authRepositoryProvider).signInWithApple(),
        ),
        // Add WhatsApp/Telegram if available in Supabase Auth providers or custom implementation
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}
