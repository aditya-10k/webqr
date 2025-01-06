import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webqr/firebase_options.dart';
import 'widgettree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase is initialized outside the UI tree to avoid conflicts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web QR',
      home: FirebaseInitScreen(),
    );
  }
}

class FirebaseInitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // If Firebase is initialized, navigate to the main app
        if (snapshot.connectionState == ConnectionState.done) {
          return const Widgettree();
        }
        // Show a loading indicator while Firebase initializes
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
