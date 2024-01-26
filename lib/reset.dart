import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter Email Id',
                    prefixIcon: Icon(Icons.person_outline),
                    // İsterseniz buraya ek özellikler ekleyebilirsiniz.
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    resetPassword(context);
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      // Şifre sıfırlama e-postası başarıyla gönderildi
      showSnackBar(context, "Şifre sıfırlama e-postası gönderildi");
      // Geri dönüş işlemi, pop ile yapıldı
      Navigator.of(context).pop();
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      showSnackBar(context, "Hata: $e");
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 700),
      ),
    );
  }
}
