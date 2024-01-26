import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_chatgpt/home.dart';
import 'package:login_chatgpt/reset.dart';
import 'package:login_chatgpt/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyCHtf2Hdft9sx7UoGXmtLTu82e5ODxb1OU",
          appId: "1:935377709175:android:7cbc4ef0735e928f6a3e72",
          messagingSenderId: "935377709175",
          projectId: "login-chatgpt-649fd",
        ))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person_2_outlined)),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password_sharp)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  signInn();
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResetPassword()));
                },
                child: Text('Reset Password'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text('Sign In Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _emailController.clear();
      _passwordController.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kullaıcı adı veya şifre yanlış"),
        duration: Duration(milliseconds: 700),
      ));
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Kullanıcı Google ile girişi iptal etti.
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Google ile giriş hatası durumunda kullanıcıya bilgi verebilirsiniz.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google ile giriş başarısız"),
          duration: Duration(milliseconds: 700),
        ),
      );
    }
  }
}
