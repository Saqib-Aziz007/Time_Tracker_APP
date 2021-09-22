import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  //
  const CustomElevatedButton({
    Key? key,
    this.child,
    this.colour,
    this.radius = 2.0,
    this.onPressed,
    this.height = 50.0,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onPressed;
  final double radius;
  final Color? colour;
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
