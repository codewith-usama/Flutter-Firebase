import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/signup_screen.dart';
import 'package:firebase_tutorial/ui/post/posts_screen.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    hintText: 'Enter your email',
                    helperText: 'abc123@gmail.com',
                  ),
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : 'Enter valid email address',
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                RoundButton(
                  text: 'Login',
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      auth
                          .signInWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      )
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PostsScreen(),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  },
                  isLoading: isLoading,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'sign up',
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
