import 'package:flutter/material.dart';
import 'package:chatter_up/services/auth/auth_service.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      if (!context.mounted) return;
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "Login Failed",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          content: Text(
            e.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Premium black and white background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
              ),
            ),
          ),

          // Subtle white accent overlay
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Logo + App Name
                    Column(
                      children: [
                        // Custom SVG-style logo using CustomPaint
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomPaint(painter: ChatterUpLogoPainter()),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'chatterUP',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Subtitle
                    const Text(
                      'Welcome back !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        height: 1.29,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email field
                    _RoundedInputField(
                      controller: _emailController,
                      placeholder: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    _RoundedInputField(
                      controller: _pwController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  height: 1.27,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Register redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.43,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'register here',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rounded Input Field Widget ───────────────────────────────────────────────

class _RoundedInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;

  const _RoundedInputField({
    required this.controller,
    required this.placeholder,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Color(0xFF999999), fontSize: 16),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 16),
        filled: true,
        fillColor: const Color(0xFF4A4A4A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Logo Custom Painter ──────────────────────────────────────────────────────

class ChatterUpLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.35; // 28/80

    // Circle
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Bar chart bars (left, middle, right)
    // Left bar: x=32, from y=32 to y=48 (normalized to 80px)
    final scale = size.width / 80;
    canvas.drawLine(
      Offset(32 * scale, 32 * scale),
      Offset(32 * scale, 48 * scale),
      paint,
    );
    // Middle bar: x=40, from y=36 to y=48
    canvas.drawLine(
      Offset(40 * scale, 36 * scale),
      Offset(40 * scale, 48 * scale),
      paint,
    );
    // Right bar: x=48, from y=28 to y=48
    canvas.drawLine(
      Offset(48 * scale, 28 * scale),
      Offset(48 * scale, 48 * scale),
      paint,
    );

    // Search handle curve
    final path = Path()
      ..moveTo(52 * scale, 52 * scale)
      ..quadraticBezierTo(58 * scale, 58 * scale, 62 * scale, 62 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
