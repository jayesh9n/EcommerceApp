import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../main_shell_view.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const Color primaryGreen = Color(0xFF00D26A);
  static const Color darkBg = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSkip() {
    ref.read(isGuestProvider.notifier).state = true;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShellView()),
        (route) => false,
      );
    }
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    final phone = '+91${_phoneController.text.trim()}';
    try {
      await ref.read(authProvider.notifier).sendOtp(phone);
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => OtpVerificationScreen(phone: phone),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('your_supabase') || lower.contains('not initialized') || lower.contains('invalid api key')) {
      return 'Supabase credentials not configured in lib/main.dart. Please add your Supabase URL and anon key.';
    }
    if (lower.contains('rate limit') || lower.contains('too many')) {
      return 'Too many OTP requests. Please wait a few minutes and try again.';
    }
    if (lower.contains('network') || lower.contains('socketexception') ||
        lower.contains('failed host lookup') || lower.contains('no such host') || lower.contains('xmlhttprequest')) {
      return 'Cannot reach Supabase server. Check your internet connection or Supabase URL in main.dart.';
    }
    if (lower.contains('invalid phone') || lower.contains('phone_number_invalid')) {
      return 'Invalid phone number format.';
    }
    if (lower.contains('sms provider') || lower.contains('sms not') || lower.contains('disabled')) {
      return 'SMS provider not configured in Supabase Dashboard (Authentication -> Providers -> Phone).';
    }
    final cleaned = raw.replaceFirst(RegExp(r'^(AuthException|Exception):\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Failed to send OTP. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                children: [
                  // ── Top Header Bar with Skip ──────────────────────────
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _handleSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 13),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Brand Header ──────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: primaryGreen.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 8)),
                            ],
                          ),
                          child: const Icon(Icons.hardware, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 16),
                        const Text('Hiranix B2B',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Text('Industrial Hardware Marketplace',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Form Card ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFF334155)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sign In / Register',
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Enter your mobile number to receive an OTP',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                          const SizedBox(height: 28),

                          // Error Banner
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Field Label
                          const Text('Mobile Number',
                              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),

                          // Phone Field with +91 prefix
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Mobile number is required';
                              if (v.trim().length != 10) return 'Enter a valid 10-digit mobile number';
                              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) {
                                return 'Enter a valid Indian mobile number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '98765 43210',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 17, letterSpacing: 1),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(left: 14, right: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                                    const SizedBox(width: 8),
                                    const Text('+91',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 10),
                                    Container(width: 1, height: 22, color: const Color(0xFF475569)),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF334155))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF334155))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primaryGreen, width: 1.5)),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444))),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
                              errorStyle: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Send OTP Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [Color(0xFF00D26A), Color(0xFF00B359)],
                                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(color: primaryGreen.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Send OTP',
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'A one-time password will be sent via SMS\nto your registered Indian mobile number',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 12, height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton.icon(
                      onPressed: _handleSkip,
                      icon: const Icon(Icons.shopping_bag_outlined, color: primaryGreen, size: 18),
                      label: const Text(
                        'Skip & Explore as Guest',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
