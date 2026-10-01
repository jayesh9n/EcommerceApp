import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;
  int _resendCountdown = 60;
  Timer? _timer;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const Color primaryGreen = Color(0xFF00D26A);
  static const Color darkBg = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _resendCountdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_resendCountdown > 0) _resendCountdown--; else t.cancel();
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _otpCode;
    if (otp.length < 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit OTP.');
      return;
    }
    setState(() { _isVerifying = true; _errorMessage = null; });
    try {
      await ref.read(authProvider.notifier).verifyOtp(widget.phone, otp);
      // AuthGate watches authProvider — when user becomes non-null,
      // it automatically replaces the route stack with MainShellView.
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
      for (final c in _controllers) c.clear();
      if (mounted) _focusNodes[0].requestFocus();
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0 || _isResending) return;
    setState(() { _isResending = true; _errorMessage = null; });
    try {
      await ref.read(authProvider.notifier).sendOtp(widget.phone);
      _startCountdown();
      for (final c in _controllers) c.clear();
      if (mounted) _focusNodes[0].requestFocus();
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('token') || lower.contains('otp') ||
        lower.contains('invalid') || lower.contains('expired') ||
        lower.contains('incorrect') || lower.contains('not match') || lower.contains('bad_json')) {
      return 'Invalid or expired OTP code. Please check and try again.';
    }
    if (lower.contains('rate limit') || lower.contains('too many')) {
      return 'Too many attempts. Please wait before trying again.';
    }
    if (lower.contains('network') || lower.contains('socketexception') ||
        lower.contains('failed host lookup') || lower.contains('no such host') || lower.contains('xmlhttprequest')) {
      return 'Cannot reach Supabase server. Check your internet connection.';
    }
    final cleaned = raw.replaceFirst(RegExp(r'^(AuthException|Exception):\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Verification failed. Please try again.';
  }

  Widget _buildOtpBox(int index) {
    final isFilled = _controllers[index].text.isNotEmpty;
    return SizedBox(
      width: 46,
      height: 58,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _controllers[index - 1].clear();
            _focusNodes[index - 1].requestFocus();
            setState(() {});
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          onChanged: (val) {
            if (val.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            }
            setState(() {});
            // Auto-verify when all 6 filled
            if (_otpCode.length == 6 && !_isVerifying) {
              Future.delayed(const Duration(milliseconds: 100), _verifyOtp);
            }
          },
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: isFilled
                ? primaryGreen.withValues(alpha: 0.15)
                : const Color(0xFF0F172A),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isFilled ? primaryGreen : const Color(0xFF334155),
                width: isFilled ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primaryGreen, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  String get _maskedPhone {
    // +919876543210 -> +91 98••••3210
    final digits = widget.phone.replaceFirst('+91', '');
    if (digits.length >= 10) {
      return '+91 ${digits.substring(0, 2)}••••${digits.substring(6)}';
    }
    return widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── Header ────────────────────────────────────────────
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: primaryGreen.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: const Icon(Icons.sms_outlined, color: primaryGreen, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const Text('Enter OTP',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('We\'ve sent a 6-digit OTP to',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(_maskedPhone,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 36),

                  // ── OTP Card ──────────────────────────────────────────
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
                    child: Column(
                      children: [
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ── 6 OTP Boxes ───────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, _buildOtpBox),
                        ),
                        const SizedBox(height: 32),

                        // ── Verify Button ─────────────────────────────
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
                              onPressed: _isVerifying ? null : _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                              ),
                              child: _isVerifying
                                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                  : const Text('Verify OTP',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Resend OTP ────────────────────────────────
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _resendCountdown > 0
                              ? Row(
                                  key: const ValueKey('countdown'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Resend OTP in ',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 13)),
                                    TweenAnimationBuilder<int>(
                                      key: ValueKey(_resendCountdown),
                                      tween: IntTween(begin: _resendCountdown, end: _resendCountdown),
                                      duration: const Duration(milliseconds: 300),
                                      builder: (_, val, __) => Text('${val}s',
                                          style: const TextStyle(color: primaryGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              : TextButton(
                                  key: const ValueKey('resend'),
                                  onPressed: _isResending ? null : _resendOtp,
                                  style: TextButton.styleFrom(foregroundColor: primaryGreen),
                                  child: _isResending
                                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: primaryGreen, strokeWidth: 2))
                                      : const Text('Resend OTP',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                        ),
                        const SizedBox(height: 12),

                        // ── Change Number ─────────────────────────────
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white38,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          child: const Text('← Change mobile number', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
