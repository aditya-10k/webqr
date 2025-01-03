import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webqr/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final Auth _auth = Auth();
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? currentUser = _auth.user;
    if (currentUser != null) {
      await currentUser.reload();
      setState(() {
        user = _auth.user;
      });
    }
  }

  Future<void> logout() async {
     await Auth().logout();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                      user != null && user!.email != null
                          ? "Welcome, ${user!.email}!"
                          : "Welcome Guest!",),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}