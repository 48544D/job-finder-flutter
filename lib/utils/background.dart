import 'package:flutter/material.dart';
import 'dart:ui';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.white,
        ),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Container()),
        Container(
            height: double.infinity,
            color: const Color.fromARGB(200, 214, 225, 242)),
        child,
      ],
    );
  }
}
