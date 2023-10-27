import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:firebase_tutorial/ui/upload_image/upload_image_screen.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null) {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UploadImageScreen(),
            ),
          );
        },
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    }
  }
}
