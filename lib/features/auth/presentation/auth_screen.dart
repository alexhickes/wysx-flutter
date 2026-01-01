import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_modal.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Stack(
        children: [
          AuthBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(16.0), child: AuthModal()),
            ),
          ),
        ],
      ),
    );
  }
}
