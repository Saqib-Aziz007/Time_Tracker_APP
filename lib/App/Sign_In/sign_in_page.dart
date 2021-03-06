import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/Sign_In/sign_in_manager.dart';
import 'package:time_tracker_app/App/Sign_In/sign_in_button.dart';
import 'package:time_tracker_app/App/Sign_In/social_sign_in_button.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/services/auth.dart';

import 'email_sign_in_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void>? showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return null;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    final bloc = Provider.of<SignInManager>(context, listen: false);
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        //fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final isLoading = Provider.of<ValueNotifier<bool>>(context);
    //final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Time Tracker',
        ),
        elevation: 2.0,
      ),
      body:
          //StreamBuilder<bool>(
          // stream: bloc.isLoadingStream,
          // initialData: false,
          // builder: (context, snapshot) {
          //   return
          _buildContent(context /*, isLoading.value*/),
      //   },
      // ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(
    BuildContext context,
    /* bool? isLoading*/
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: 50, width: 50.0, child: _buildHeader(/*isLoading!8*/)),
          //_buildHeader(),
          const SizedBox(
            height: 42.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign In with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign In with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            text: 'Go Anonymous',
            textColor: Colors.black87,
            color: Colors.lime.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(/*bool isLoading*/) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.only(left: 165, right: 165),
        child:
            SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
      );
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
