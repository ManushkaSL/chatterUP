import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // Animation controllers
  late AnimationController _containerController;
  late AnimationController _logoController;
  late AnimationController _fieldsController;
  late AnimationController _buttonController;
  late AnimationController _floatingController;

  // Animations
  late Animation<double> _containerScaleAnimation;
  late Animation<double> _containerOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _fieldsSlideAnimation;
  late Animation<double> _fieldsOpacityAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _floatingAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _containerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fieldsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Setup animations
    _containerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _containerController, curve: Curves.elasticOut),
    );

    _containerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _containerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
        );

    _fieldsSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _fieldsController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fieldsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fieldsController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _buttonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    _containerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _fieldsController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _buttonController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _containerController.dispose();
    _logoController.dispose();
    _fieldsController.dispose();
    _buttonController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  // Register method with mounted check and loading state
  Future<void> register() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    final _auth = AuthService();

    if (_pwController.text != _confirmPwController.text) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      _showErrorDialog("Passwords don't match");
      return;
    }

    try {
      await _auth.signUpWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );

      if (!mounted) return;
      _showSuccessDialog("Account created successfully!");
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text("Error"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text("Success"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Animated background elements
          _buildFloatingElements(colorScheme),

          // Main content
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: AnimatedBuilder(
                animation: _containerController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _containerScaleAnimation.value,
                    child: Opacity(
                      opacity: _containerOpacityAnimation.value,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withAlpha(204),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: colorScheme.outline.withAlpha(51),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animated logo section
                                SlideTransition(
                                  position: _logoSlideAnimation,
                                  child: FadeTransition(
                                    opacity: _logoOpacityAnimation,
                                    child: ScaleTransition(
                                      scale: _logoScaleAnimation,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  colorScheme.primary
                                                      .withOpacity(0.1),
                                                  colorScheme.secondary
                                                      .withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                            child: Image.asset(
                                              'lib/assets/logo.png',
                                              height: 120,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            "Join ChatterUp!",
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Create your account and start connecting",
                                            style: TextStyle(
                                              color: colorScheme.onSurface
                                                  .withAlpha(153),
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Animated form fields
                                SlideTransition(
                                  position: _fieldsSlideAnimation,
                                  child: FadeTransition(
                                    opacity: _fieldsOpacityAnimation,
                                    child: Column(
                                      children: [
                                        // Email field with animation
                                        _buildAnimatedTextField(
                                          controller: _emailController,
                                          hintText: "Email Address",
                                          icon: Icons.email_outlined,
                                          obscureText: false,
                                          delay: 0,
                                          colorScheme: colorScheme,
                                        ),

                                        const SizedBox(height: 16),

                                        // Password field with animation
                                        _buildAnimatedTextField(
                                          controller: _pwController,
                                          hintText: "Password",
                                          icon: Icons.lock_outline,
                                          obscureText: true,
                                          delay: 100,
                                          colorScheme: colorScheme,
                                        ),

                                        const SizedBox(height: 16),

                                        // Confirm Password field with animation
                                        _buildAnimatedTextField(
                                          controller: _confirmPwController,
                                          hintText: "Confirm Password",
                                          icon: Icons.lock_outline,
                                          obscureText: true,
                                          delay: 200,
                                          colorScheme: colorScheme,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Animated register button
                                ScaleTransition(
                                  scale: _buttonScaleAnimation,
                                  child: FadeTransition(
                                    opacity: _buttonOpacityAnimation,
                                    child: Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          colors: [
                                            colorScheme.primary,
                                            colorScheme.secondary,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.primary
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          onTap: _isLoading ? null : register,
                                          child: Center(
                                            child: _isLoading
                                                ? SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: colorScheme
                                                              .onPrimary,
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : Text(
                                                    "C R E A T E   A C C O U N T",
                                                    style: TextStyle(
                                                      color:
                                                          colorScheme.onPrimary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Login redirect with animation
                                FadeTransition(
                                  opacity: _buttonOpacityAnimation,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withAlpha(179),
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          widget.onTap?.call();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            "Sign In",
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
    required int delay,
    required ColorScheme colorScheme,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MyTextField(
                hintText: hintText,
                obscureText: obscureText,
                controller: controller,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(76),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating circle 1
            Positioned(
              top: 100 + (20 * _floatingAnimation.value),
              left: 50,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.1),
                      colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            // Floating circle 2
            Positioned(
              bottom: 150 + (15 * (1 - _floatingAnimation.value)),
              right: 80,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.secondary.withOpacity(0.1),
                      colorScheme.primary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            // Floating circle 3
            Positioned(
              top: 250 + (10 * _floatingAnimation.value),
              right: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.05),
                      colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
