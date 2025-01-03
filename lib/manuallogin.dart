import 'package:flutter/material.dart';
import 'package:webqr/auth.dart';
import 'package:webqr/homepage.dart';

class Manuallogin extends StatefulWidget {
   Manuallogin({super.key});

  @override
  State<Manuallogin> createState() => _ManualloginState();
}

class _ManualloginState extends State<Manuallogin> {

  String? errorMessage='';
  bool isLogin = false;

  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();  

  Future<void> login() async {
    try {
      await Auth().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.push(context , MaterialPageRoute(builder: (context) => const Homepage()));
      setState(() {
        isLogin = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    if (errorMessage!.isNotEmpty) {
      return Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: login,
      child: const Text('Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',
        style: TextStyle(
          color: Colors.black,
          
        ),),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 400,
            width: 300,
            padding: const EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                //Text('Login Page'),
                _entryField('Email', _emailController),
                SizedBox(height: 20),
                _entryField('Password', _passwordController),
                SizedBox(height: 20),
                _errorMessage(),
                SizedBox(height: 20),
                _submitButton(),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}