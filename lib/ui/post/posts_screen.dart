import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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

  final reference = FirebaseDatabase.instance.ref('Post');
  final TextEditingController searchController = TextEditingController();

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

            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(child: Text('Loading')),
                query: reference,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                    );
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(title),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            // const Divider(),
            // Expanded(
            //   child: StreamBuilder(
            //     stream: reference.onValue,
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(child: CircularProgressIndicator());
            //       } else {
            //         Map<dynamic, dynamic> map =
            //             snapshot.data!.snapshot.value as dynamic;
            //         List<dynamic> list = [];
            //         list.clear();
            //         list = map.values.toList();

            //         return ListView.builder(
            //           itemCount: snapshot.data!.snapshot.children.length,
            //           itemBuilder: (context, index) {
            //             return ListTile(title: Text(list[index]['title']));
            //           },
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
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
