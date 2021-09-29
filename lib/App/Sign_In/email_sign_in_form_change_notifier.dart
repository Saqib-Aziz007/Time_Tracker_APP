import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/Sign_In/email_sign_in_change_model.dart';
import 'package:time_tracker_app/App/Sign_In/form_submit_button.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({Key? key, required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;
  // EmailSignInForm({Key? key, required this.auth}) : super(key: key);
  // final AuthBase auth;
  static create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        exception: e,
        title: 'Sign in failed',
      );
    }
  }

  void _toggleForm() {
    widget.model.toggleForm();
    _emailController.clear();
    _passwordController.clear();
  }

  void _onEmailEditingField() {
    final _newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  List<Widget> _buildChildren() {
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
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryButtonText,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            model.secondaryButtonText,
          ),
          TextButton(
            onPressed: !model.isLoading ? () => _toggleForm() : null,
            child: Text(
              model.thirdButtonText,
            ),
          ),
        ],
      )
    ];
  }

  TextField _buildPasswordField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _onEmailEditingField(),
      onChanged: widget.model.updateEmail,
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
}
