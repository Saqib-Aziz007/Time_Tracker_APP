import 'dart:async';

import 'package:time_tracker_app/App/Sign_In/email_sign_in_model.dart';
import 'package:time_tracker_app/App/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _emailModelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _emailModelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _emailModelController.close();
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInUserWithEmailAndPassword(
            _model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
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
    final formType = _model.formType == EmailSignInFormType.signIn
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
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _emailModelController.add(_model);
  }
}
