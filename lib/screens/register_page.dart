import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/components/my_botton.dart';
import 'package:chatter_up/components/my_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // Register method with mounted check
  Future<void> register() async {
    final _auth = AuthService();

    if (_pwController.text != _confirmPwController.text) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Passwords don't match")),
      );
      return;
    }

    try {
      await _auth.signUpWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );

      // Optionally, navigate or show success message here
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface.withAlpha((204)), // 0.8 opacity
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withAlpha((25)), // 0.1 opacity
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/assets/logo.png', height: 150),
                    const SizedBox(height: 20),
                    Text(
                      "Let's create an Account for ya!",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join us and start chatting.",
                      style: TextStyle(
                        color: colorScheme.onSurface.withAlpha(
                          153,
                        ), // 0.6 opacity
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email field
                    MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: _emailController,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                        51,
                      ), // 0.2 opacity
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: _pwController,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                        51,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    MyTextField(
                      hintText: "Confirm Password",
                      obscureText: true,
                      controller: _confirmPwController,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                        51,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    MyBotton(
                      text: "R E G I S T E R",
                      onTap: register,
                      backgroundColor: colorScheme.secondary,
                      textColor: colorScheme.onSecondary,
                    ),
                    const SizedBox(height: 20),

                    // Login redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account?",
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(179),
                          ), // 0.7 opacity
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            " Login now",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
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
  }
}
