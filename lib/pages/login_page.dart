import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plo_project/components/my_button.dart';
import 'package:plo_project/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';
  String emailError = '';
  String passwordError = '';

  bool authError = false;

  // String authErrorMessage = '';
  void clearPasswordText() {
    passwordController.clear();
  }

  //signUserIn
  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        authError = false;
        // authErrorMessage = '';
        errorMessage = '';
        emailError =
            emailController.text.isEmpty ? 'Email cannot be empty' : '';
        passwordError =
            passwordController.text.isEmpty ? 'password cannot be empty' : '';
      });

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        return;
      }
    }
    // show loading circle

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigator.pop(context);

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //wrong email
      if (e.code == 'user-not-found') {
        //show error-to-user
        setState(() {
          clearPasswordText();
          authError = true;
          errorMessage = 'Username/password is wrong';
        });
      }
      //wrong password
      else if (e.code == 'wrong-password') {
        //show error-to-user
        setState(() {
          authError = true;
          clearPasswordText();
          errorMessage = 'Username/password is wrong';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // logo
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset(
                      'assets/images/pennstate_logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  //welcome message
                  Text(
                    "People Link One",
                    style: GoogleFonts.roboto(
                        fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "사람을 하나로",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 30),
                  //username textfield
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text("이메일"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  MyTextField(
                      controller: emailController,
                      hintText: 'E-mail',
                      obscureText: false,
                      isError: authError,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be Empty';
                        }
                        return null;
                      }),
                  const SizedBox(height: 15),
                  //password textfield
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text("Password"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    isError: authError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Forgot",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text("Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //sign in button
                  MyButton(
                    onTap: signUserIn,
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 20),
                  //register button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[600],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an Account?'),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  "Register now",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
