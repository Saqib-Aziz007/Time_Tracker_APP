import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/components/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(context,
        title: title,
        content: _message(exception),
        actionText: 'OK',
        cancelActionButton: null);

String? _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message;
  } else {
    return exception.toString();
  }
}
