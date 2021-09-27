import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/components/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          height: 44.0,
          radius: 4.0,
          colour: Colors.indigo,
          onPressed: onPressed,
        );
}
