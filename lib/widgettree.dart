import 'package:webqr/homepage.dart';
import 'package:webqr/landingpage.dart';

import 'auth.dart';
import 'package:flutter/material.dart';
import 'manuallogin.dart';

class Widgettree extends StatefulWidget {
  const Widgettree({super.key});

  @override
  State<Widgettree> createState() => _WidgettreeState();
}

class _WidgettreeState extends State<Widgettree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const Homepage();
        } else {
          return  Landingpage();
        }
      });
  }
}