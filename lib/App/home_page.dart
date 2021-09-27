import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'components/show_alert_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // const HomePage({Key? key, required this.firebaseAuth}) : super(key: key);
  // final AuthBase firebaseAuth;

  void _signOut(BuildContext context) async {
    try {
      final firebaseAuth = Provider.of<AuthBase>(context, listen: false);
      await firebaseAuth.signOut();
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout?',
        content: 'Are you sure that you want to Log out?',
        actionText: 'Logout',
        cancelActionButton: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
