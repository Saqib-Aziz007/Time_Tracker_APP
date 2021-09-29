import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/home/models/job.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'package:time_tracker_app/App/services/database.dart';
import '../components/show_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

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
    final database = Provider.of<Database>(context, listen: false);
    database.jobsStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
      body: _buildContents(context),
    );
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(
        Job(
          name: 'Blogging',
          ratePerHour: 10,
        ),
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder(
      stream: database.jobsStream(),
      builder: (context, AsyncSnapshot<List<Job>> snapshot) {
        if (snapshot.hasData) {
          final List<Job>? jobs = snapshot.data;
          final List<Widget> children =
              jobs!.map((job) => Text(job.name)).toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          //print(snapshot.error);
          return const Center(
            child: Text('Some error occurred!!!'),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
