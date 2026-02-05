import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'core/services/notification_service.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ckcshepcojxbztcztkha.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrY3NoZXBjb2p4Ynp0Y3p0a2hhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDk4OTQsImV4cCI6MjA3NTMyNTg5NH0.w6gJVM-NBCCBcD2brwJLgOb56GODspBJWMIi7PCVsXM',
  );

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();

    debugPrint('✅ Firebase and notifications initialized');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization skipped: $e');
    debugPrint('Please configure Firebase using the setup guide');
  }

  runApp(const ProviderScope(child: WysxApp()));
}
