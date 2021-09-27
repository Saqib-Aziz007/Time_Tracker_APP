import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';

Future<bool?> showAlertDialog(
  BuildContext context, {
  required String title,
  required String? content,
  required String actionText,
  required String? cancelActionButton,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content!),
          actions: [
            if (cancelActionButton != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelActionButton),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content!),
        actions: [
          if (cancelActionButton != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionButton),
            ),
          CupertinoDialogAction(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(actionText),
            ),
          ),
        ],
      );
    },
  );
}
