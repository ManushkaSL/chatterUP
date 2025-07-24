import 'package:chatter_up/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("S E T T I N G S"),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Theme.of(
            context,
          ).colorScheme.surfaceVariant.withAlpha((0.9 * 255).toInt()),
          child: ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text("Dark Mode"),
            trailing: Switch.adaptive(
              value: isDark,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
