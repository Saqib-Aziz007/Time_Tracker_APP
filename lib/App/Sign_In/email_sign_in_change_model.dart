import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/App/Sign_In/validation.dart';
import 'package:time_tracker_app/App/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? 'Need an account? '
      : 'Have an account? ';

  String get thirdButtonText =>
      formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';

  bool get canSubmit =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  String? get passwordErrorText {
    final bool showErrorText =
        submitted && !passwordValidator.isValid(password);
    return showErrorText ? inValidPasswordErrorText : null;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? inValidEmailErrorText : null;
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInUserWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(
        isLoading: false,
      );
    }
  }

  void toggleForm() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
