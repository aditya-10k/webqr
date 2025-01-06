import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:webqr/manuallogin.dart';
import 'package:webqr/weblogincomp.dart';


class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  String? sessionId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _createSession();
  }

  Future<void> _createSession() async {
    try {
      String id = Uuid().v4();
      setState(() {
        sessionId = id;
        isLoading = true;
      });

      await FirebaseFirestore.instance.collection('web_sessions').doc(id).set({
        'isAuthenticated': false,
        'userId': null,
        'email': null,
        'displayName': null,
        'photoURL': null,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error creating session: $e");
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Failed to create session. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || sessionId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Creating session..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Landing Page',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: sessionId!,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            WebLoginListener(sessionId: sessionId!), 

            Text(
              'Scan this QR code to log in',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Manuallogin(),
                  ),
                );
              },
              child: const Text(
                'Login Manually',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
