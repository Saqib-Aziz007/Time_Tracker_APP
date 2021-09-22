import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/Sign_In/sign_in_button.dart';
import 'package:time_tracker_app/App/Sign_In/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Time Tracker',
        ),
        elevation: 2.0,
      ),
      body: _buildPadding(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 42.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign In with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign In with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed: () {},
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            onPressed: () {},
            text: 'Sign In with email',
            textColor: Colors.white,
            color: Colors.teal.shade700,
          ),
          const Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            onPressed: () {},
            text: 'Go Anonymous',
            textColor: Colors.black87,
            color: Colors.lime.shade300,
          ),
        ],
      ),
    );
  }
}
