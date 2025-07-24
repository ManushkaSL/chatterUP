import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/components/my_botton.dart';
import 'package:chatter_up/components/my_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      if (!context.mounted) return; // safety check for async
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
                color: colorScheme.surface.withAlpha((0.8 * 255).round()),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/assets/logo.png', height: 150),
                    const SizedBox(height: 20),
                    Text(
                      "Welcome to chatterUP",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Let’s get you signed in.",
                      style: TextStyle(
                        color: colorScheme.onSurface.withAlpha(
                          (0.6 * 255).round(),
                        ),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Use your custom MyTextField here
                    MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: _emailController,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                        (0.2 * 255).round(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: _pwController,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                        (0.2 * 255).round(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Use your custom MyBotton for consistent button style
                    MyBotton(
                      text: "L O G I N",
                      onTap: () => login(context),
                      backgroundColor: colorScheme.secondary,
                      textColor: colorScheme.onSecondary,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(
                              (0.7 * 255).round(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Register now",
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
