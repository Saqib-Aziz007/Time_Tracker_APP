import 'package:flutter/material.dart';

import '../models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key? key, required this.job, required this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //tileColor: Colors.indigo[100],
      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
