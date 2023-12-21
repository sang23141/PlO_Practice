import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plo_project/components/my_button.dart';
import 'package:plo_project/components/my_textfield.dart';
//import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool success = false;

  //For invalid username and password error message
  String errorMessage = '';
  //empty email textfield error
  String emailError = '';
  //empty password textfield error
  String passwordError = '';
  //for not having matching password and confirm password textfield
  String notMatchingMessage = '';
  bool authError = false;

  // String authErrorMessage = '';
  void clearPasswordText() {
    passwordController.clear();
  }

  //signUserUp
  void signUserUp() async {
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
      //check if password and confirm password matches
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        notMatchingMessage = ('Password don\'t match');
        //show error message,
      }
      // Navigator.pop(context);

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
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
                  const SizedBox(height: 15),
                  // logo
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/images/pennstate_logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  //welcome message
                  Text(
                    "Sign Up",
                    style: GoogleFonts.roboto(
                        fontSize: 18, color: Colors.grey[700]),
                  ),
                  // const SizedBox(height: 5),
                  // Text(
                  //   "사람을 하나로",
                  //   style: GoogleFonts.roboto(
                  //     fontSize: 16,
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  //username textfield
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text("이름"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  MyTextField(
                      controller: nameController,
                      hintText: '이름',
                      obscureText: false,
                      isError: authError,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be Empty';
                        }
                        return null;
                      }),

                  const SizedBox(height: 15),
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
                        String pattern =  r'^[A-Za-z\d]+@*\.?psu\.edu$';
                        if( !RegExp(pattern).hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                      ),
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
                      String pattern =  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
                        if( !RegExp(pattern).hasMatch(value)) {
                          return 'Please enter a valid Password';
                        }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:24.0),
                    child: FlutterPwValidator(
                       controller: passwordController,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          width: 400,
                          height: 150,
                          onSuccess: () {
                            setState(() {
                              success = true;
                            });
                            print("MATCHED");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Password is matched")));
                          },
                          onFail: () {
                            setState(() {
                              success= false;
                            });
                            print("Not matched");
                          }
                          
                    ),
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
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    isError: authError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password cannot be empty';
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
                          notMatchingMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  //sign in button
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 10),
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
                              Text('Already have an Account?'),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  "Login now",
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
