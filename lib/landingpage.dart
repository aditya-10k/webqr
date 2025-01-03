import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webqr/manuallogin.dart';


class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {

  

  String? _sessionid;
  String link = 'https://adityakathe.netlify.app/';
  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 20),
            QrImageView(data: link, size: 200),

          InkWell(
            onTap:(){Navigator.push(context , MaterialPageRoute(builder: (context) =>  Manuallogin()));},
            child: const Text('Login Manually'),
          )
          ],
        ),
      ),
    );
  }
}