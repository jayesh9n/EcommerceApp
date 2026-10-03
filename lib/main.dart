import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/providers.dart';
import 'views/main_shell_view.dart';
import 'views/auth/phone_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://YOUR_SUPABASE_URL.supabase.co',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  } catch (_) {
    // Graceful fallback if offline
  }

  runApp(
    const ProviderScope(
      child: IndustrialEcommerceApp(),
    ),
  );
}

class IndustrialEcommerceApp extends StatelessWidget {
  const IndustrialEcommerceApp({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiranix B2B Hardware',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111827),
          elevation: 0,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

/// Watches auth state and routes to Login or Main shell accordingly.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final isGuest = ref.watch(isGuestProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
      child: (user != null || isGuest)
          ? const MainShellView(key: ValueKey('shell'))
          : const PhoneLoginScreen(key: ValueKey('phone-login')),
    );
  }
}

