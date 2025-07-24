import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String chatRoomID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID})
    : chatRoomID = _generateChatRoomID(
        receiverID,
        AuthService().getCurrentUser()!.uid,
      );

  static String _generateChatRoomID(String user1, String user2) {
    List<String> ids = [user1, user2]..sort();
    return ids.join('_');
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await _chatServices.sendMessage(widget.receiverID, message);
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessagesStream(widget.chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data?.docs ?? [];
        if (messages.isEmpty) {
          return const Center(child: Text('Start a conversation!'));
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      final isMe = data['senderID'] == _authService.getCurrentUser()?.uid;

      final messageBubbleColor = isMe
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondaryContainer;

      final textColor = isMe
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSecondaryContainer;

      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: messageBubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                data['message'] ?? '',
                style: TextStyle(fontSize: 15, color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(data['timestamp']),
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    try {
      final dt = timestamp.toDate();
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return '';
    }
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
