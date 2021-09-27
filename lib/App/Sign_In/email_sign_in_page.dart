import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/Sign_In/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  // const EmailSignInPage({Key? key, required this.firebaseAuth})
  //     : super(key: key);
  // final AuthBase firebaseAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in',
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
