import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/verify_sms.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignIn with Phone'),
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
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 50),
              RoundButton(
                text: 'Send code',
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  auth
                      .verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text.toString(),
                        verificationCompleted: (_) {},
                        verificationFailed: (error) =>
                            Utils().toastMessage(error.toString()),
                        codeSent: (String verificationId, int? token) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VerifySms(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (error) =>
                            Utils().toastMessage(
                          error.toString(),
                        ),
                      )
                      .onError((error, stackTrace) =>
                          Utils().toastMessage(error.toString()));
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
