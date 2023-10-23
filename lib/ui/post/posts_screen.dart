import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:firebase_tutorial/ui/post/add_posts.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    super.key,
  });

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Posts Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 20)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPosts(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}