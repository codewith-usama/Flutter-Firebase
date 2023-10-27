// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/firestore_services/add_firestore_data.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController updateTitleController = TextEditingController();

  final fireStoreStream =
      FirebaseFirestore.instance.collection('Admin').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Admin');

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('FireStore Screen'),
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search word',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: fireStoreStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                // else if(snapshot.hasError)
                //   return Utils().toastMessage('Some Error');
                else
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: IconButton(
                                  onPressed: () => showMyDialog(
                                      snapshot.data!.docs[index]['title']
                                          .toString(),
                                      snapshot.data!.docs[index]['id']
                                          .toString()),
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              PopupMenuItem(
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .doc(snapshot.data!.docs[index]['id']
                                            .toString())
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              )
                            ],
                          ),
                          // onTap: () {
                          // ref
                          //     .doc(
                          //         snapshot.data!.docs[index]['id'].toString())
                          //     .update({
                          //       'title': 'Usama',
                          //     })
                          //     .then(
                          //         (value) => Utils().toastMessage('updated'))
                          //     .onError(
                          //       (error, stackTrace) =>
                          //           Utils().toastMessage(error.toString()),
                          //     );
                          // },
                          title: Text(
                            snapshot.data!.docs[index]['title'].toString(),
                          ),
                          subtitle: Text(
                            snapshot.data!.docs[index]['id'].toString(),
                          ),
                        );
                      },
                    ),
                  );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddFireStoreData(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    updateTitleController.text = title;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextFormField(
          controller: updateTitleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.doc(id).update({
                'title': updateTitleController.text.toString(),
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
