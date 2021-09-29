import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/Sign_In/form_submit_button.dart';
import 'package:time_tracker_app/App/Sign_In/validation.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  EmailSignInForm({Key? key}) : super(key: key);

  // EmailSignInForm({Key? key, required this.auth}) : super(key: key);
  // final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late EmailSignInFormType _formType = EmailSignInFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInUserWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //debugPrint(e.toString());
      showExceptionAlertDialog(
        context,
        exception: e,
        title: 'Sign in failed',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleForm() {
    _submitted = false;
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _onEmailEditingField() {
    final _newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  List<Widget> _buildChildren() {
    final bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    final _primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final _secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? '
        : 'Have an account? ';
    final _thirdText =
        _formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';

    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8.0,
      ),
      _buildPasswordField(),
      const SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit : null,
        text: _primaryText,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _secondaryText,
          ),
          TextButton(
            onPressed: !_isLoading ? _toggleForm : null,
            child: Text(
              _thirdText,
            ),
          ),
        ],
      )
    ];
  }

  TextField _buildPasswordField() {
    final bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.inValidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (_password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    final bool showErrorText =
        _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.inValidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _onEmailEditingField,
      onChanged: (_email) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
