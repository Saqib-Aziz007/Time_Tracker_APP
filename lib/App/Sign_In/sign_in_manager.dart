import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/App/services/auth.dart';

//First the class is bloc because we are using the stream controller and streams
//now we are using the ValueNotifier so not it is a bloc so we converted it to SignInManager
class SignInManager {
  SignInManager({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream => _isLoadingController.stream;
  //
  // void dispose() {
  //   _isLoadingController.close();
  // }
  //
  // void _setLoadingStream(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethode) async {
    try {
      isLoading.value = true;
      return await signInMethode();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signInAnonymously() async => _signIn(auth.signInAnonymously);
  Future<User?> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
  Future<User?> signInWithFacebook() async => _signIn(auth.signInWithFacebook);
}
