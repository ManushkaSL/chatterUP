import 'package:chatter_up/components/my_drawer.dart';
import 'package:chatter_up/components/user_tile.dart';
import 'package:chatter_up/screens/chat_page.dart';
import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat & Auth Services
  final ChatServices _chatService = ChatServices();
  final AuthService _authService = AuthService();

  void logout() {
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "H O M E",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildUserList(context),
      ),
    );
  }

  // Build a list of users except for the current logged-in user
  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Error case
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong."));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data ?? [];

        // Filter out the current user
        final otherUsers = users
            .where(
              (userData) =>
                  userData["email"] != _authService.getCurrentUser()!.email,
            )
            .toList();

        if (otherUsers.isEmpty) {
          return const Center(child: Text("No other users found."));
        }

        // Return animated list
        return ListView.builder(
          itemCount: otherUsers.length,
          itemBuilder: (context, index) {
            final userData = otherUsers[index];
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  // Build individual user list item
  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: UserTile(
        text: userData["email"],
        onTap: () {
          // Go to chat page with selected user
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      ),
    );
  }
}
