import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String chatRoomID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  }) : chatRoomID = _generateChatRoomID(receiverID, AuthService().getCurrentUser()!.uid);

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

      // Wait for message to build before scrolling
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
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 141, 141, 141),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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

      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              /*if (!isMe && data['senderEmail'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    data['senderEmail'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),*/
              Text(
                data['message'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.surface,),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(data['timestamp']),
                style: const TextStyle(fontSize: 10, color: Color.fromARGB(115, 0, 0, 0)),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
