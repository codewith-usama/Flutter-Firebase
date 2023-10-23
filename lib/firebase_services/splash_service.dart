import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:firebase_tutorial/ui/post/posts_screen.dart';
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
              builder: (context) => const PostsScreen(),
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
