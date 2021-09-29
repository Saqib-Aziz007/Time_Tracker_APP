import 'package:time_tracker_app/App/Sign_In/validation.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
