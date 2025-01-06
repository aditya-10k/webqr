import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> createSession(String sessionId) async {
    await _firestore.collection('web_sessions').doc(sessionId).set({
      'isAuthenticated': false,
      'userId': null,
      'email': null,
      'displayName': null,
      'photoURL': null,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> authenticateSession(String sessionId, User user) async {
    await _firestore.collection('web_sessions').doc(sessionId).update({
      'isAuthenticated': true,
      'userId': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'No Name',
      'photoURL': user.photoURL ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
