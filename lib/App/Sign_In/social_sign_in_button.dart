import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/App/components/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    Key? key,
    required String assetName,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          height: 44.0,
          radius: 4.0,
          colour: color,
          onPressed: onPressed,
        );
}
