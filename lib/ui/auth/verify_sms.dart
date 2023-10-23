import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/post/posts_screen.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';

class VerifySms extends StatefulWidget {
  final String verificationId;
  const VerifySms({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerifySms> createState() => _VerifySmsState();
}

class _VerifySmsState extends State<VerifySms> {
  final TextEditingController smsController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: smsController,
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit code',
                ),
              ),
              const SizedBox(height: 50),
              RoundButton(
                text: 'Verify code',
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: smsController.text.toString(),
                  );
                  try {
                    await auth.signInWithCredential(credential).then(
                          (value) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PostsScreen(),
                            ),
                          ),
                        );
                  } catch (error) {
                    Utils().toastMessage(error.toString());
                  }
                },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
