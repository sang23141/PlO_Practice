import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plo_project/pages/home_page.dart';
import 'package:plo_project/pages/log_in_or_register.dart';
//import 'package:plo_project/pages/login_page.dart';
 
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          //if User logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          else {
            return LogInOrRegister();
          }
        }
      )
    );
  }
}