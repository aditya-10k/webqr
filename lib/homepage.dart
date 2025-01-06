import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webqr/auth.dart';
import 'package:webqr/landingpage.dart';

class Homepage extends StatefulWidget {
  final String? sessionId; 

  const Homepage({super.key, this.sessionId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Auth _auth = Auth();
  User? user;
  String? userEmailFromFirestore; 

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? currentUser = _auth.user;
    
    // Force reload if user is already authenticated
    await FirebaseAuth.instance.currentUser?.reload(); 
    currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
      print("Authenticated user: ${user?.email}");
    } else {
      print("No authenticated user found.");
    }

    if (widget.sessionId != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = 
            await FirebaseFirestore.instance.collection('web_sessions').doc(widget.sessionId).get(); 
        
        if (userSnapshot.exists) {
          print("User snapshot exists: ${userSnapshot.data()}");
          if (userSnapshot.data()?['isAuthenticated'] == true) {
            setState(() {
              userEmailFromFirestore = userSnapshot.data()?['email']; 
            });
            print("Fetched user email from Firestore: $userEmailFromFirestore");
          } else {
            print("Session not authenticated in Firestore.");
          }
        } else {
          print("No document found for session ID: ${widget.sessionId}");
        }
      } catch (e) {
        print("Error fetching user data from Firestore: $e");
      }
    }
  }

  Future<void> logout() async {
    try {
      await Auth().logout();
      print("User logged out successfully.");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userEmailFromFirestore != null 
                  ? "Welcome, $userEmailFromFirestore!" 
                  : user != null && user!.email != null 
                      ? "Welcome, ${user!.email}!" 
                      : "Welcome Guest!",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    await logout(); // Ensure logout is complete before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Landingpage()),
    );
  },
  child: const Text('Logout'),
),

          ],
        ),
      ),
    );
  }
}
