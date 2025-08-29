import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/components/my_botton.dart';
import 'package:chatter_up/components/my_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Main animation controller for entrance effects
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse animation for floating elements
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
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
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withAlpha((0.1 * 255).round()),
                  colorScheme.secondary.withAlpha((0.05 * 255).round()),
                  colorScheme.tertiary.withAlpha((0.08 * 255).round()),
                ],
              ),
            ),
          ),

          // Animated floating elements
          ...List.generate(
            6,
            (index) => AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Positioned(
                  left:
                      (size.width * (0.1 + (index * 0.15))) +
                      (20 *
                          math.sin(
                            _pulseController.value * 2 * math.pi + index,
                          )),
                  top:
                      (size.height * (0.1 + (index * 0.12))) +
                      (15 *
                          math.cos(
                            _pulseController.value * 2 * math.pi + index,
                          )),
                  child: Transform.scale(
                    scale: _pulseAnimation.value * (0.5 + index * 0.1),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(
                          (0.3 * 255).round(),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated lines
          CustomPaint(
            size: Size(size.width, size.height),
            painter: AnimatedLinesPainter(
              animation: _pulseController,
              colorScheme: colorScheme,
            ),
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withAlpha(
                              (0.85 * 255).round(),
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outline.withAlpha(
                                (0.2 * 255).round(),
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withAlpha(
                                  (0.1 * 255).round(),
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo with glow effect
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withAlpha(
                                          (0.3 * 255).round(),
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'lib/assets/logo.png',
                                    height: 120,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Title with gradient text effect
                                Center(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.secondary,
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
                                      "Welcome to chatterUP",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Text(
                                  "Let's get you signed in.",
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.7 * 255).round(),
                                    ),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Email field with enhanced styling
                                _buildEnhancedTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  icon: Icons.email_outlined,
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(height: 20),

                                // Password field with enhanced styling
                                _buildEnhancedTextField(
                                  controller: _pwController,
                                  hintText: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(height: 32),

                                // Enhanced login button
                                _buildEnhancedButton(
                                  text: "L O G I N",
                                  onTap: () => login(context),
                                  colorScheme: colorScheme,
                                  isLoading: _isLoading,
                                ),
                                const SizedBox(height: 24),

                                // Register link with better styling
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Not a member?",
                                      style: TextStyle(
                                        color: colorScheme.onSurface.withAlpha(
                                          (0.7 * 255).round(),
                                        ),
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: widget.onTap,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: colorScheme.primary.withAlpha(
                                            (0.1 * 255).round(),
                                          ),
                                        ),
                                        child: Text(
                                          "Register now",
                                          style: TextStyle(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ColorScheme colorScheme,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: MyTextField(
        hintText: hintText,
        obscureText: isPassword,
        controller: controller,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(
          (0.3 * 255).round(),
        ),
      ),
    );
  }

  Widget _buildEnhancedButton({
    required String text,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha((0.3 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLinesPainter extends CustomPainter {
  final Animation<double> animation;
  final ColorScheme colorScheme;

  AnimatedLinesPainter({required this.animation, required this.colorScheme})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw animated curved lines
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final progress = (animation.value + i * 0.3) % 1.0;

      paint.color = colorScheme.primary.withAlpha(
        ((0.1 + i * 0.05) * 255).round(),
      );

      final startX = size.width * (0.1 + i * 0.3);
      final startY = size.height * 0.2;
      final endX = size.width * (0.9 - i * 0.2);
      final endY = size.height * 0.8;

      final controlX =
          startX +
          (endX - startX) * 0.5 +
          50 * math.sin(progress * 2 * math.pi);
      final controlY =
          startY +
          (endY - startY) * 0.3 +
          30 * math.cos(progress * 2 * math.pi);

      path.moveTo(startX, startY);
      path.quadraticBezierTo(controlX, controlY, endX, endY);

      canvas.drawPath(path, paint);
    }

    // Draw floating dots along the lines
    for (int i = 0; i < 5; i++) {
      final dotPaint = Paint()
        ..color = colorScheme.secondary.withAlpha(
          ((0.4 - i * 0.05) * 255).round(),
        )
        ..style = PaintingStyle.fill;

      final progress = (animation.value * 2 + i * 0.2) % 1.0;
      final x = size.width * (0.2 + progress * 0.6);
      final y = size.height * (0.3 + 0.4 * math.sin(progress * math.pi));

      canvas.drawCircle(
        Offset(x, y),
        2 + math.sin(animation.value * 4 * math.pi) * 1,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(AnimatedLinesPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
