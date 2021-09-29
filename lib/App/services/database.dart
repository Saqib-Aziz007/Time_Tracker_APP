import 'package:time_tracker_app/App/home/models/job.dart';
import 'package:time_tracker_app/App/services/apipaths.dart';
import 'package:time_tracker_app/App/services/firestore_services.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _services = FirestoreServices.instance;
  @override
  Future<void> createJob(Job job) async => _services.setJob(
        path: APIPaths.job(uid, 'job_abc'),
        data: job.toMap(),
      );
  @override
  Stream<List<Job>> jobsStream() => _services.collectionStream(
        path: APIPaths.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
