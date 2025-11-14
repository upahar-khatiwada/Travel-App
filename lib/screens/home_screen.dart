import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) => const LoginPage(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
