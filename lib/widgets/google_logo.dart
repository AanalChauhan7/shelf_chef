import 'package:flutter/material.dart';

/// Official Pixel-Perfect 4-Color Google "G" Logo Icon using user's asset image.
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/google_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.g_mobiledata_rounded, size: size, color: Colors.blue),
      ),
    );
  }
}
