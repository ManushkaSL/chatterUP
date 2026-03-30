import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send message
  Future<void> sendMessage(String receiverID, String message) async {
    try {
      final currentUserID = _auth.currentUser!.uid;
      final currentUserEmail = _auth.currentUser!.email!;
      final chatRoomID = _generateChatRoomID(currentUserID, receiverID);

      // Add message to messages collection
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add({
            'senderID': currentUserID,
            'senderEmail': currentUserEmail,
            'receiverID': receiverID,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Update chat room metadata for faster access to conversations
      final ids = [currentUserID, receiverID]..sort();
      await _firestore.collection('chat_rooms').doc(chatRoomID).set({
        'user1ID': ids[0],
        'user2ID': ids[1],
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageFrom': currentUserEmail,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessagesStream(String chatRoomID) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Generate chat room ID
  static String _generateChatRoomID(String user1, String user2) {
    List<String> ids = [user1, user2]..sort();
    return ids.join('_');
  }

  // Get users stream (optional)
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Get conversations stream for the current user (chat list)
  Stream<QuerySnapshot> getConversationsStream() {
    final currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .where('user1ID', isEqualTo: currentUserID)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Delete a conversation
  Future<void> deleteConversation(String chatRoomID) async {
    try {
      // Delete all messages in the chat room
      final messagesRef = _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages');

      final messages = await messagesRef.get();
      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      // Delete the chat room itself
      await _firestore.collection('chat_rooms').doc(chatRoomID).delete();
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }
}
