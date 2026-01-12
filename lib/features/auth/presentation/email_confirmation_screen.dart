import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailConfirmationScreen extends ConsumerStatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  ConsumerState<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState
    extends ConsumerState<EmailConfirmationScreen> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Give Supabase a moment to process the deep link
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _navigateToHome();
    } else {
      // Listen for updates - maybe it's still processing
      final subscription = Supabase.instance.client.auth.onAuthStateChange
          .listen((data) {
            if (data.session != null && mounted) {
              _navigateToHome();
            } else if (data.event == AuthChangeEvent.userUpdated) {
              _navigateToHome();
            }
          });

      // Safety timeout
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && Supabase.instance.client.auth.currentSession == null) {
          setState(() {
            _hasError = true;
            _errorMessage =
                "Could not verify session. Please try logging in manually.";
          });
          subscription.cancel();
        }
      });
    }
  }

  void _navigateToHome() {
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_hasError) ...[
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Verification Failed',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/auth'),
                  child: const Text('Back to Login'),
                ),
              ] else ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Verifying your email...'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
