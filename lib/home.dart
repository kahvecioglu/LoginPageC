import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null)
              Text(
                'Welcome, ${user!.email}',
                style: TextStyle(fontSize: 20),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
