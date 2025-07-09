
import 'package:chatter_up/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices{

  //get instatnce of firebase and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        //go through each individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }
  //send message
  Future<void> sendMessage(String receiverID, message) async{
    //get current user inof
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new msg
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timestamp: timestamp
    );
    //construct chat room ID for the two users(sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();// sort the ids (this ensure the chatrooID is the same for any 2 people)
    String chatrRoomID = ids.join('_'); 

    //add new message to database
    await _firestore
    .collection("chat_rooms")
    .doc(chatrRoomID)
    .collection("messages")
    .add(newMessage.toMap());
  }
  //get messages
  Stream<QuerySnapshot> getMessages(String useID, otherUserID){
    //construct a chatroom ID for the two users
    List<String> ids = [useID, otherUserID];
    ids.sort();
    String chatrooID = ids.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatrooID)
    .collection("messages")
    .orderBy("timestamp", descending: false)
    .snapshots();

  }
}