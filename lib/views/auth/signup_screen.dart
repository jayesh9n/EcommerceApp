import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  String? _errorMessage;
  String? _successMessage;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'Please agree to the Terms & Conditions to continue.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await ref.read(authProvider.notifier).signUp(
            _emailController.text.trim(),
            _passwordController.text,
          );
      // If the user is now set (demo mode or auto-confirmed), AuthGate
      // will navigate automatically. For email-confirmation flow, show banner.
      final user = ref.read(authProvider);
      if (mounted && user == null) {
        setState(() {
          _successMessage =
              'Account created! Please check your email to confirm your account, then sign in.';
        });
      }
      // If user != null, AuthGate handles the navigation automatically.
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('already registered') || lower.contains('already been registered') || lower.contains('user_already_exists')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (lower.contains('network') || lower.contains('socketexception') || lower.contains('failed host lookup') || lower.contains('no such host')) {
      return 'Cannot reach server. Check your internet connection and try again.';
    }
    if (lower.contains('password should be') || lower.contains('weak_password')) {
      return 'Password must be at least 6 characters long.';
    }
    if (lower.contains('invalid email') || lower.contains('email_address_invalid')) {
      return 'Please enter a valid email address.';
    }
    if (lower.contains('rate limit') || lower.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return 'Registration failed. Please try again.';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                          ),
                          child: const Icon(Icons.hardware, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 16),
                        const Text('Hiranix B2B', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Text('Industrial Hardware Marketplace', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 12))],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Create account', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Register for B2B wholesale access', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                          const SizedBox(height: 28),

                          if (_errorMessage != null) ...[
                            _StatusBanner(message: _errorMessage!, isError: true),
                            const SizedBox(height: 20),
                          ],
                          if (_successMessage != null) ...[
                            _StatusBanner(message: _successMessage!, isError: false),
                            const SizedBox(height: 20),
                          ],

                          _AuthTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'John Smith',
                            icon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Full name is required';
                              if (v.trim().length < 2) return 'Name must be at least 2 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _AuthTextField(
                            controller: _companyController,
                            label: 'Company Name',
                            hint: 'ABC Constructions Pvt. Ltd.',
                            icon: Icons.business_outlined,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Company name is required';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _AuthTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            hint: '+91 98765 43210',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Phone number is required';
                              if (v.trim().length < 10) return 'Enter a valid phone number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _AuthTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'you@company.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Email is required';
                              if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _AuthTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white38, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password is required';
                              if (v.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _AuthTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white38, size: 20),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your password';
                              if (v != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Terms & Conditions
                          GestureDetector(
                            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _agreedToTerms ? primaryGreen : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _agreedToTerms ? primaryGreen : const Color(0xFF475569),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _agreedToTerms
                                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.5),
                                      children: const [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(text: 'Terms & Conditions', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
                                        TextSpan(text: ' and '),
                                        TextSpan(text: 'Privacy Policy', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          _GradientButton(label: 'Create Account', isLoading: _isLoading, onPressed: _handleSignup),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Already have account
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?  ', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const LoginScreen(),
                              transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          ),
                          child: const Text('Sign in', style: TextStyle(color: primaryGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable widgets (same as login_screen.dart)
class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.white38, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF334155))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF334155))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF00D26A), width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444))),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
            errorStyle: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF00D26A), Color(0xFF00B359)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF00D26A).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _StatusBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError ? const Color(0xFFEF4444) : const Color(0xFF00D26A);
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
  }
}
