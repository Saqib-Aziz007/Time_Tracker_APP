import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/components/show_alert_dialog.dart';
import 'package:time_tracker_app/App/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/App/services/database.dart';

import '../models/job.dart';

class EditJobForm extends StatefulWidget {
  const EditJobForm({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(
      context,
      listen: false,
    );
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobForm(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  State<EditJobForm> createState() => _EditJobFormState();
}

class _EditJobFormState extends State<EditJobForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;
  bool? _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onEmailEditingField() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((event) => event.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            content: 'Please use a different name',
            title: 'Name already used',
            actionText: 'Ok',
            cancelActionButton: '',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromDateAndTime();
          final job = Job(
            id: id,
            name: _name ?? '',
            ratePerHour: _ratePerHour ?? 0,
          );
          widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          exception: e,
          title: 'Sign in failed',
        );
      } finally {
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _emailFocusNode,
                    initialValue: _name,
                    decoration: const InputDecoration(
                      labelText: 'Job Name',
                    ),
                    validator: (value) =>
                        value!.isNotEmpty ? null : 'Name can\'t be empty',
                    onSaved: (value) => _name = value!,
                    onEditingComplete: _onEmailEditingField,
                    enabled: _isLoading == false,
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
                    decoration: const InputDecoration(
                      labelText: 'Rate per hour',
                    ),
                    onSaved: (value) => _ratePerHour = int.parse(value ?? '0'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    enabled: _isLoading == false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
