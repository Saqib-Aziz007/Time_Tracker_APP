import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/home/job/job_list_tile.dart';
import 'package:time_tracker_app/App/home/models/job.dart';
import 'package:time_tracker_app/App/services/auth.dart';
import 'package:time_tracker_app/App/services/database.dart';
import '../../components/show_alert_dialog.dart';
import 'edit_job_form.dart';
import 'item_list_builder.dart';

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
        onPressed: () => EditJobForm.show(context),
      ),
      body: _buildContents(context),
    );
  }

  _delete(BuildContext context, Job job) {
    try {
      final database = Provider.of<Database>(context, listen: false);
      database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder(
      stream: database.jobsStream(),
      builder: (context, AsyncSnapshot<List<Job>> snapshot) {
        return ItemListBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (BuildContext context, item) => Dismissible(
                  key: Key('job-${item.id}'),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(context, item),
                  child: JobListTile(
                    onTap: () => EditJobForm.show(context, job: item),
                    job: item,
                  ),
                ));
        // if (snapshot.hasData) {
        //   final List<Job>? jobs = snapshot.data;
        //   if (jobs!.isNotEmpty) {
        //     final List<Widget> children = jobs
        //         .map((job) => JobListTile(
        //               onTap: () => EditJobForm.show(context, job: job),
        //               job: job,
        //             ))
        //         .toList();
        //     return ListView(
        //       children: children,
        //     );
        //   }
        //   return const EmptyContent();
        // }
        // if (snapshot.hasError) {
        //   //print(snapshot.error);
        //   return const Center(
        //     child: Text('Some error occurred!!!'),
        //   );
        // }
        // return const CircularProgressIndicator();
      },
    );
  }
}
