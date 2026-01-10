import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Supabase.initialize(
    url: 'https://ckcshepcojxbztcztkha.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrY3NoZXBjb2p4Ynp0Y3p0a2hhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDk4OTQsImV4cCI6MjA3NTMyNTg5NH0.w6gJVM-NBCCBcD2brwJLgOb56GODspBJWMIi7PCVsXM',
  );

  runApp(const ProviderScope(child: WysxApp()));
}
