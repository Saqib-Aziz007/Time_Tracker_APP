import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/home_page.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'Sign_In/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  // const LandingPage({Key? key, required this.firebaseAuth}) : super(key: key);
  // final AuthBase firebaseAuth;
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.active) {
          final User? user = snapShot.data;
          if (user == null) {
            return const SignInPage();
          }
          return const HomePage();
        }
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      },
    );
  }
}
