import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {
  final TextEditingController postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Admin');

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add post to Firestore'),
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
                  final id = Timestamp.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id,
                  }).then(
                    (value) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils().toastMessage('Added');
                      Navigator.pop(context);
                    },
                  ).onError(
                    (error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils().toastMessage(
                        error.toString(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
