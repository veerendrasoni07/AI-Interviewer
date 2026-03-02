import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/view/authentication/sign_up_screen.dart';
import 'package:frontend/view/screens/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin()async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator(color: Colors.deepPurple,)),
      );
      final success = await AuthController().login(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
        ref: ref,
      );
      if(success){
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
      else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const _FuturisticBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 36,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.graphic_eq_rounded,
                                color: colorScheme.primary,
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI INTERVIEWER',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue your interview sessions',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _NeonInput(
                            controller: _emailController,
                            label: 'Email',
                            prefixIcon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _NeonInput(
                            controller: _passwordController,
                            label: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Minimum 6 characters';
                              }
                              return null;
                            },
                            suffix: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: colorScheme.primary,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                  onChanged: (value) => setState(
                                    () => _rememberMe = value ?? false,
                                  ),
                                ),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                elevation: 12,
                                shadowColor: colorScheme.primary.withValues(
                                  alpha: 0.55,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Start Interview',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'By continuing, you agree to our Terms & Privacy Policy',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                ),
                                child: Text("Signup"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonInput extends StatelessWidget {
  const _NeonInput({
    required this.controller,
    required this.label,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(
          prefixIcon,
          color: colorScheme.primary.withValues(alpha: 0.9),
        ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _FuturisticBackground extends StatelessWidget {
  const _FuturisticBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF04050A), Color(0xFF0B1022), Color(0xFF090F1C)],
        ),
      ),
      child: CustomPaint(
        painter: _GridGlowPainter(accent: colorScheme.primary),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GridGlowPainter extends CustomPainter {
  _GridGlowPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const step = 38.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              accent.withValues(alpha: 0.22),
              accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.18, size.height * 0.2),
              radius: math.max(size.width, size.height) * 0.5,
            ),
          );

    final glow2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.cyanAccent.withValues(alpha: 0.16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.88, size.height * 0.85),
              radius: math.max(size.width, size.height) * 0.45,
            ),
          );

    canvas.drawRect(Offset.zero & size, glow);
    canvas.drawRect(Offset.zero & size, glow2);
  }

  @override
  bool shouldRepaint(covariant _GridGlowPainter oldDelegate) =>
      oldDelegate.accent != accent;
}
