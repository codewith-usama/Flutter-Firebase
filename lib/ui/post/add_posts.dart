import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  final TextEditingController postController = TextEditingController();

  final firebaseDatabase = FirebaseDatabase.instance.ref('Post');

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add a post'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              RoundButton(
                text: 'Add',
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  firebaseDatabase
                      .child(DateTime.now().millisecondsSinceEpoch.toString())
                      .set({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': postController.text.toString(),
                  }).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data Added'),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}