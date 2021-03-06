import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  //
  const CustomElevatedButton({
    Key? key,
    this.child,
    required this.colour,
    required this.radius,
    this.onPressed,
    required this.height,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onPressed;
  final double radius;
  final Color colour;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black87,
          primary: colour,
          onSurface: colour,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
        ),
        child: child,
      ),
    );
  }
}
