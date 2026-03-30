import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Generate call room ID
  static String _generateCallRoomID(String user1, String user2) {
    List<String> ids = [user1, user2]..sort();
    return 'call_${ids.join('_')}';
  }

  // Initiate a call
  Future<void> initiateCall(
    String receiverID,
    String receiverEmail,
    String callType, // 'audio' or 'video'
  ) async {
    try {
      final currentUserID = _auth.currentUser!.uid;
      final currentUserEmail = _auth.currentUser!.email!;
      final callRoomID = _generateCallRoomID(currentUserID, receiverID);

      await _firestore.collection('calls').doc(callRoomID).set({
        'callID': callRoomID,
        'callerID': currentUserID,
        'callerEmail': currentUserEmail,
        'receiverID': receiverID,
        'receiverEmail': receiverEmail,
        'callType': callType, // 'audio' or 'video'
        'status': 'ringing', // ringing, accepted, rejected, ended
        'startTime': FieldValue.serverTimestamp(),
        'endTime': null,
      });
    } catch (e) {
      throw Exception('Failed to initiate call: $e');
    }
  }

  // Accept call
  Future<void> acceptCall(String callRoomID) async {
    try {
      await _firestore.collection('calls').doc(callRoomID).update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to accept call: $e');
    }
  }

  // Reject call
  Future<void> rejectCall(String callRoomID) async {
    try {
      await _firestore.collection('calls').doc(callRoomID).update({
        'status': 'rejected',
        'endTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reject call: $e');
    }
  }

  // End call
  Future<void> endCall(String callRoomID) async {
    try {
      await _firestore.collection('calls').doc(callRoomID).update({
        'status': 'ended',
        'endTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to end call: $e');
    }
  }

  // Get call stream
  Stream<DocumentSnapshot> getCallStream(String callRoomID) {
    return _firestore.collection('calls').doc(callRoomID).snapshots();
  }

  // Get incoming calls stream
  Stream<QuerySnapshot> getIncomingCallsStream() {
    final receiverID = _auth.currentUser!.uid;
    return _firestore
        .collection('calls')
        .where('receiverID', isEqualTo: receiverID)
        .where('status', isEqualTo: 'ringing')
        .snapshots();
  }

  // Get call history
  Stream<QuerySnapshot> getCallHistoryStream() {
    final userID = _auth.currentUser!.uid;
    return _firestore
        .collection('calls')
        .where('callerID', isEqualTo: userID)
        .orderBy('startTime', descending: true)
        .snapshots();
  }
}
