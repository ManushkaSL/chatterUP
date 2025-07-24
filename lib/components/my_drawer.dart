import 'package:chatter_up/screens/settings_page.dart';
import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              drawerItem(
                icon: Icons.home,
                title: "H O M E",
                onTap: () => Navigator.pop(context),
                color: colorScheme.onBackground,
              ),
              drawerItem(
                icon: Icons.settings,
                title: "S E T T I N G S",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
                color: colorScheme.onBackground,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: drawerItem(
              icon: Icons.logout,
              title: "L O G O U T",
              onTap: () => logout(context),
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
