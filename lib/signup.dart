import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  signUp(context);
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    try {
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        showSnackBar(context, 'Lütfen tüm alanları doldurunuz');
        return;
      }

      if (!isValidEmail(email)) {
        showSnackBar(context, 'Lütfen geçerli bir mail adresi giriniz');
        return;
      }

      if (password.length < 6) {
        showSnackBar(context, 'Pasaport daha uzun olmalı');
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _emailController.clear();
      _passwordController.clear();
      Navigator.pop(context); // Sign up ekranından çıkış yap
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Bu email zaten kullanılıyor');
      }
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}
