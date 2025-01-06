import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webqr/homepage.dart';

class WebLoginListener extends StatefulWidget {
  final String sessionId;
  
  const WebLoginListener({Key? key, required this.sessionId}) : super(key: key);

  @override
  _WebLoginListenerState createState() => _WebLoginListenerState();
}

class _WebLoginListenerState extends State<WebLoginListener> {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseFirestore.instance
        .collection('web_sessions')
        .doc(widget.sessionId)
        .snapshots()
        .listen((snapshot) {
      // Check if the snapshot exists and has valid data
      if (snapshot.exists) {
        // Log the snapshot data for debugging
        debugPrint('Snapshot Data: ${snapshot.data()}');
        
        // Check if the user is authenticated
        if (snapshot.data()?['isAuthenticated'] == true) {
          // Log and navigate if authenticated
          debugPrint('User authenticated, navigating to Homepage...');
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage(sessionId: widget.sessionId)),
          );
        } else {
          // Log if user is not authenticated yet
          debugPrint('User not authenticated yet.');
        }
      } else {
        // Log if the document doesn't exist or has no data
        debugPrint('Snapshot does not exist or has no data.');
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Hide this widget after navigation
  }
}
